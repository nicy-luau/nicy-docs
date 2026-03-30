#!/usr/bin/env bash
set -Eeuo pipefail
umask 022

NICY_REPO="${NICY_REPO:-nicy-luau/nicy}"
RUNTIME_REPO="${RUNTIME_REPO:-nicy-luau/nicyrtdyn}"
FORCE="${FORCE:-0}"

log() {
  printf '[INFO] %s\n' "$*" >&2
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

fail() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

on_error() {
  local exit_code="$?"
  local line_no="$1"
  fail "Command failed at line ${line_no}: ${BASH_COMMAND} (exit ${exit_code})"
}

trap 'on_error ${LINENO}' ERR

require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || fail "Required command not found: $cmd"
}

ensure_termux_cmds() {
  if ! is_termux_env; then
    return 0
  fi

  command -v pkg >/dev/null 2>&1 || fail "Termux detected, but 'pkg' is not available."
  log "Updating Termux package index"
  pkg update -y >/dev/null 2>&1 || warn "pkg update failed; continuing with current package index"

  local -a packages=()
  command -v curl >/dev/null 2>&1 || packages+=("curl")
  command -v unzip >/dev/null 2>&1 || packages+=("unzip")
  command -v find >/dev/null 2>&1 || packages+=("findutils")
  command -v termux-elf-cleaner >/dev/null 2>&1 || packages+=("termux-elf-cleaner")
  [[ -f "${PREFIX:-}/lib/libz.so" ]] || packages+=("zlib")
  [[ -f "${PREFIX:-}/lib/libc++_shared.so" ]] || packages+=("libc++")

  if [[ ${#packages[@]} -gt 0 ]]; then
    log "Installing missing Termux packages: ${packages[*]}"
    pkg install -y "${packages[@]}" >/dev/null 2>&1 || fail "Failed to install required Termux packages: ${packages[*]}"
  fi
}

api_get() {
  local url="$1"
  curl -fsSL -H "User-Agent: nicy-installer" "$url"
}

latest_release_json() {
  local repo="$1"
  local url="https://api.github.com/repos/$repo/releases/latest"
  local data
  if data="$(api_get "$url" 2>/dev/null)"; then
    printf '%s' "$data"
    return 0
  fi

  url="https://api.github.com/repos/$repo/releases?per_page=20"
  data="$(api_get "$url")"
  [[ -n "$data" && "$data" != "[]" ]] || fail "No release found in $repo"
  printf '%s' "$data"
}

extract_tag() {
  local json="$1"
  local tag
  tag="$(printf '%s' "$json" | tr -d '\n' | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')"
  [[ -n "$tag" && "$tag" != "$json" ]] || fail "Failed to read release tag"
  printf '%s' "$tag"
}

download_asset() {
  local url="$1"
  local out="$2"
  curl -fL -H "User-Agent: nicy-installer" "$url" -o "$out"
}

is_termux_env() {
  [[ -n "${TERMUX_VERSION:-}" ]] && return 0
  [[ "${PREFIX:-}" == *"com.termux"* ]] && return 0
  command -v termux-info >/dev/null 2>&1 && return 0
  [[ "$(uname -o 2>/dev/null || true)" == "Android" ]] && return 0
  return 1
}

detect_platform_target() {
  local os arch abi
  os="$(uname -s)"
  arch="$(uname -m)"
  abi="$(getprop ro.product.cpu.abi 2>/dev/null || true)"

  if is_termux_env; then
    log "Detected Android/Termux environment (uname=$arch, abi=${abi:-unknown})"
    case "$abi|$arch" in
      arm64-v8a*|*aarch64*|*arm64*)
        echo "android-arm"
        ;;
      armeabi-v7a*|*armv7l*|*armv8l*|*\|arm)
        echo "android-v7"
        ;;
      *)
        fail "Unsupported Android architecture (uname=$arch abi=${abi:-unknown})"
        ;;
    esac
    return 0
  fi

  case "$os" in
    Linux)
      case "$arch" in
        x86_64|amd64) echo "linux-x64" ;;
        aarch64|arm64) echo "linux-arm" ;;
        i686|i386) echo "linux-x86" ;;
        *) fail "Unsupported Linux architecture: $arch" ;;
      esac
      ;;
    Darwin)
      case "$arch" in
        x86_64|amd64) echo "mac-x64" ;;
        arm64|aarch64) echo "mac-arm" ;;
        *) fail "Unsupported macOS architecture: $arch" ;;
      esac
      ;;
    *)
      fail "Unsupported system: $os"
      ;;
  esac
}

runtime_filename_for_target() {
  local target="$1"
  if [[ "$target" == mac-* ]]; then
    echo "libnicyrtdyn.dylib"
  else
    echo "libnicyrtdyn.so"
  fi
}

ensure_path_persisted() {
  local install_root="$1"
  local enable_ld_path="$2"
  local shells=("$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc")
  local line="export PATH=\"$install_root:\$PATH\""
  local ld_line=""
  if [[ "$enable_ld_path" == "1" ]]; then
    ld_line="export LD_LIBRARY_PATH=\"$install_root:${PREFIX:-}/lib:\${LD_LIBRARY_PATH:-}\""
  fi

  for rc in "${shells[@]}"; do
    [[ -f "$rc" ]] || continue
    grep -Fq "$install_root" "$rc" || printf '\n%s\n' "$line" >> "$rc"
    if [[ -n "$ld_line" ]]; then
      grep -Fq "LD_LIBRARY_PATH=\"$install_root:${PREFIX:-}/lib" "$rc" || printf '%s\n' "$ld_line" >> "$rc"
    fi
  done

  if [[ ! -f "$HOME/.profile" && ! -f "$HOME/.bashrc" && ! -f "$HOME/.zshrc" ]]; then
    printf '%s\n' "$line" >> "$HOME/.profile"
    [[ -n "$ld_line" ]] && printf '%s\n' "$ld_line" >> "$HOME/.profile"
  fi

  case ":${PATH}:" in
    *":$install_root:"*) ;;
    *) export PATH="$install_root:$PATH" ;;
  esac

  if [[ -n "$ld_line" ]]; then
    export LD_LIBRARY_PATH="$install_root:${PREFIX:-}/lib:${LD_LIBRARY_PATH:-}"
  fi
}

main() {
  local target install_root runtime_install_dir legacy_install_root tmp_root dl_dir ex_dir tmp_base
  local nicy_release_json rt_release_json nicy_tag rt_tag
  local nicy_zip rt_zip nicy_url rt_url
  local nicy_asset runtime_asset runtime_file
  local nicy_bin runtime_bin
  local termux_mode

  termux_mode="0"
  if is_termux_env; then
    termux_mode="1"
    ensure_termux_cmds
  fi

  require_cmd curl
  require_cmd unzip
  require_cmd find

  target="$(detect_platform_target)"
  log "Selected target: $target"

  if is_termux_env && [[ -n "${PREFIX:-}" ]]; then
    install_root="${INSTALL_ROOT:-$PREFIX/bin}"
    runtime_install_dir="${RUNTIME_INSTALL_DIR:-$PREFIX/lib}"
    legacy_install_root="$PREFIX/opt/nicy/bin"
  else
    install_root="${INSTALL_ROOT:-$HOME/.local/Nicy/bin}"
    runtime_install_dir="$install_root"
    legacy_install_root=""
  fi
  log "Install directory: $install_root"
  log "Runtime directory: $runtime_install_dir"

  tmp_base="${TMPDIR:-/tmp}"
  tmp_root="$tmp_base/nicy-install-$(date +%s)-$$"
  mkdir -p "$tmp_root"
  dl_dir="$tmp_root/downloads"
  ex_dir="$tmp_root/extract"
  mkdir -p "$dl_dir" "$ex_dir" "$install_root" "$runtime_install_dir"
  log "Temporary workspace: $tmp_root"

  trap '[[ -n "${tmp_root:-}" ]] && rm -rf "$tmp_root"' EXIT

  log "Fetching latest releases"
  nicy_release_json="$(latest_release_json "$NICY_REPO")"
  rt_release_json="$(latest_release_json "$RUNTIME_REPO")"
  nicy_tag="$(extract_tag "$nicy_release_json")"
  rt_tag="$(extract_tag "$rt_release_json")"
  log "Nicy release: $nicy_tag"
  log "Runtime release: $rt_tag"

  nicy_asset="nicy-$target.zip"
  runtime_asset="nicyrtdyn-$target.zip"
  nicy_url="https://github.com/$NICY_REPO/releases/download/$nicy_tag/$nicy_asset"
  rt_url="https://github.com/$RUNTIME_REPO/releases/download/$rt_tag/$runtime_asset"

  log "CLI asset: $nicy_asset"
  log "Runtime asset: $runtime_asset"

  nicy_zip="$dl_dir/nicy.zip"
  rt_zip="$dl_dir/runtime.zip"

  log "Downloading CLI"
  download_asset "$nicy_url" "$nicy_zip"
  log "Downloading runtime"
  download_asset "$rt_url" "$rt_zip"

  log "Extracting archives"
  unzip -oq "$nicy_zip" -d "$ex_dir/nicy"
  unzip -oq "$rt_zip" -d "$ex_dir/runtime"

  nicy_bin="$(find "$ex_dir/nicy" -type f -name "nicy" | head -n1 || true)"
  runtime_file="$(runtime_filename_for_target "$target")"
  runtime_bin="$(find "$ex_dir/runtime" -type f -name "$runtime_file" | head -n1 || true)"

  [[ -n "$nicy_bin" ]] || fail "Could not locate nicy binary after extraction"
  [[ -n "$runtime_bin" ]] || fail "Could not locate runtime binary '$runtime_file' after extraction"

  cp -f "$nicy_bin" "$install_root/nicy"
  chmod +x "$install_root/nicy"
  cp -f "$runtime_bin" "$runtime_install_dir/$runtime_file"
  chmod 755 "$runtime_install_dir/$runtime_file"

  if [[ "$termux_mode" == "1" && -n "${PREFIX:-}" ]]; then
    mv -f "$install_root/nicy" "$install_root/nicy.bin"
    cat > "$install_root/nicy" <<EOF
#!/usr/bin/env sh
export LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/bin:\${LD_LIBRARY_PATH:-}"
if [ -f "${PREFIX}/lib/libc++_shared.so" ]; then
  export LD_PRELOAD="${PREFIX}/lib/libc++_shared.so\${LD_PRELOAD:+:\$LD_PRELOAD}"
fi
exec "${install_root}/nicy.bin" "\$@"
EOF
    chmod +x "$install_root/nicy"

    mkdir -p "$PREFIX/lib"
    cp -f "$runtime_bin" "$PREFIX/lib/$runtime_file"
    chmod 755 "$PREFIX/lib/$runtime_file"
    cp -f "$runtime_bin" "$install_root/$runtime_file"
    chmod 755 "$install_root/$runtime_file"

    if [[ ! -f "$PREFIX/lib/libc++_shared.so" ]]; then
      if command -v pkg >/dev/null 2>&1; then
        log "Installing libc++ runtime dependency for Android (libc++_shared.so)"
        pkg install -y libc++ >/dev/null 2>&1 || true
      fi
    fi

    if [[ -f "$PREFIX/lib/libc++_shared.so" ]]; then
      chmod 755 "$PREFIX/lib/libc++_shared.so"
      cp -f "$PREFIX/lib/libc++_shared.so" "$install_root/libc++_shared.so"
      chmod 755 "$install_root/libc++_shared.so"
    else
      warn "Missing libc++_shared.so. Run: pkg install libc++"
    fi

    mkdir -p "$legacy_install_root"
    cat > "$legacy_install_root/nicy" <<EOF
#!/usr/bin/env sh
export LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/bin:\${LD_LIBRARY_PATH:-}"
if [ -f "${PREFIX}/lib/libc++_shared.so" ]; then
  export LD_PRELOAD="${PREFIX}/lib/libc++_shared.so\${LD_PRELOAD:+:\$LD_PRELOAD}"
fi
exec "${install_root}/nicy" "\$@"
EOF
    chmod +x "$legacy_install_root/nicy"
    cp -f "$runtime_install_dir/$runtime_file" "$legacy_install_root/$runtime_file"
    chmod 755 "$legacy_install_root/$runtime_file"
    if [[ -f "$PREFIX/lib/libc++_shared.so" ]]; then
      cp -f "$PREFIX/lib/libc++_shared.so" "$legacy_install_root/libc++_shared.so"
      chmod 755 "$legacy_install_root/libc++_shared.so"
    fi

    if command -v termux-elf-cleaner >/dev/null 2>&1; then
      log "Running termux-elf-cleaner on installed binaries/libraries"
      termux-elf-cleaner "$install_root/nicy.bin" "$install_root/$runtime_file" "$PREFIX/lib/$runtime_file" >/dev/null 2>&1 || true
      if [[ -f "$legacy_install_root/$runtime_file" ]]; then
        termux-elf-cleaner "$legacy_install_root/$runtime_file" >/dev/null 2>&1 || true
      fi
    fi

    hash -r 2>/dev/null || true
  fi

  ensure_path_persisted "$install_root" "$termux_mode"

  log "Running quick runtime check"
  if "$install_root/nicy" runtime-version >/dev/null 2>&1; then
    log "Runtime check passed"
  else
    warn "Nicy installed, but runtime-version failed in quick check"
  fi

  echo "Installation completed"
  echo "Nicy: $install_root/nicy"
  echo "Runtime: $runtime_install_dir/$runtime_file"
  echo "Target: $target"
  echo "Nicy release: $nicy_tag"
  echo "Runtime release: $rt_tag"
  echo "Nicy asset: $nicy_asset"
  echo "Runtime asset: $runtime_asset"
  echo "PATH updated with: $install_root"
  if [[ "$termux_mode" == "1" && -n "${PREFIX:-}" ]]; then
    echo "Legacy compatibility path: $legacy_install_root"
    echo "If shell still resolves old command cache, run: hash -r"
  fi
}

main "$@"
