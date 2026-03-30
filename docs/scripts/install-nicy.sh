#!/usr/bin/env bash
set -Eeuo pipefail

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

asset_url_from_release_json() {
  local json="$1"
  local asset_name="$2"
  local one_line escaped_name url
  escaped_name="$(printf '%s' "$asset_name" | sed -E 's/[][(){}.+*?^$|]/\\&/g')"
  one_line="$(printf '%s' "$json" | tr -d '\n')"
  url="$(printf '%s' "$one_line" | grep -Eo "\"name\":\"$escaped_name\"[^}]*\"browser_download_url\":\"[^\"]+\"" | head -n1 | sed -E 's/.*\"browser_download_url\":\"([^\"]+)\".*/\1/' || true)"
  [[ -n "$url" ]] && printf '%s' "$url"
}

pick_asset() {
  local release_json="$1"
  shift
  local candidate url
  for candidate in "$@"; do
    url="$(asset_url_from_release_json "$release_json" "$candidate" || true)"
    if [[ -n "$url" ]]; then
      printf '%s|%s' "$candidate" "$url"
      return 0
    fi
  done
  return 1
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
  local shells=("$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc")
  local line="export PATH=\"$install_root:\$PATH\""

  for rc in "${shells[@]}"; do
    [[ -f "$rc" ]] || continue
    grep -Fq "$install_root" "$rc" || printf '\n%s\n' "$line" >> "$rc"
  done

  if [[ ! -f "$HOME/.profile" && ! -f "$HOME/.bashrc" && ! -f "$HOME/.zshrc" ]]; then
    printf '%s\n' "$line" >> "$HOME/.profile"
  fi

  case ":${PATH}:" in
    *":$install_root:"*) ;;
    *) export PATH="$install_root:$PATH" ;;
  esac
}

main() {
  require_cmd curl
  require_cmd unzip
  require_cmd find

  local target install_root tmp_root dl_dir ex_dir tmp_base
  local nicy_release_json rt_release_json nicy_tag rt_tag
  local nicy_zip rt_zip nicy_url rt_url
  local nicy_asset runtime_asset runtime_file
  local nicy_bin runtime_bin
  local nicy_pick runtime_pick
  local -a nicy_candidates runtime_candidates

  target="$(detect_platform_target)"
  log "Selected target: $target"

  if is_termux_env && [[ -n "${PREFIX:-}" ]]; then
    install_root="${INSTALL_ROOT:-$PREFIX/opt/nicy/bin}"
  else
    install_root="${INSTALL_ROOT:-$HOME/.local/Nicy/bin}"
  fi
  log "Install directory: $install_root"

  tmp_base="${TMPDIR:-/tmp}"
  tmp_root="$tmp_base/nicy-install-$(date +%s)-$$"
  mkdir -p "$tmp_root"
  dl_dir="$tmp_root/downloads"
  ex_dir="$tmp_root/extract"
  mkdir -p "$dl_dir" "$ex_dir" "$install_root"
  log "Temporary workspace: $tmp_root"

  trap '[[ -n "${tmp_root:-}" ]] && rm -rf "$tmp_root"' EXIT

  log "Fetching latest releases"
  nicy_release_json="$(latest_release_json "$NICY_REPO")"
  rt_release_json="$(latest_release_json "$RUNTIME_REPO")"
  nicy_tag="$(extract_tag "$nicy_release_json")"
  rt_tag="$(extract_tag "$rt_release_json")"
  log "Nicy release: $nicy_tag"
  log "Runtime release: $rt_tag"

  if [[ "$target" == "android-v7" ]]; then
    nicy_candidates=("nicy-android-v7.zip" "nicy-android-armv7.zip" "nicy-android-arm32.zip")
    runtime_candidates=("nicyrtdyn-android-v7.zip" "nicyrtdyn-android-armv7.zip" "nicyrtdyn-android-arm32.zip")
  elif [[ "$target" == "android-arm" ]]; then
    nicy_candidates=("nicy-android-arm.zip" "nicy-android-aarch64.zip" "nicy-android-arm64.zip" "nicy-android-arm64-v8a.zip")
    runtime_candidates=("nicyrtdyn-android-arm.zip" "nicyrtdyn-android-aarch64.zip" "nicyrtdyn-android-arm64.zip" "nicyrtdyn-android-arm64-v8a.zip")
  else
    nicy_candidates=("nicy-$target.zip")
    runtime_candidates=("nicyrtdyn-$target.zip")
  fi

  nicy_pick="$(pick_asset "$nicy_release_json" "${nicy_candidates[@]}" || true)"
  runtime_pick="$(pick_asset "$rt_release_json" "${runtime_candidates[@]}" || true)"
  [[ -n "$nicy_pick" ]] || fail "No matching CLI asset found for target $target"
  [[ -n "$runtime_pick" ]] || fail "No matching runtime asset found for target $target"

  nicy_asset="${nicy_pick%%|*}"
  nicy_url="${nicy_pick#*|}"
  runtime_asset="${runtime_pick%%|*}"
  rt_url="${runtime_pick#*|}"

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
  cp -f "$runtime_bin" "$install_root/$runtime_file"

  ensure_path_persisted "$install_root"

  log "Running quick runtime check"
  if "$install_root/nicy" runtime-version >/dev/null 2>&1; then
    log "Runtime check passed"
  else
    warn "Nicy installed, but runtime-version failed in quick check"
  fi

  echo "Installation completed"
  echo "Nicy: $install_root/nicy"
  echo "Runtime: $install_root/$runtime_file"
  echo "Target: $target"
  echo "Nicy release: $nicy_tag"
  echo "Runtime release: $rt_tag"
  echo "Nicy asset: $nicy_asset"
  echo "Runtime asset: $runtime_asset"
  echo "PATH updated with: $install_root"
}

main "$@"
