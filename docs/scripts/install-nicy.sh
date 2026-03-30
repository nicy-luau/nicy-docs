#!/usr/bin/env bash
set -euo pipefail

NICY_REPO="${NICY_REPO:-nicy-luau/nicy}"
RUNTIME_REPO="${RUNTIME_REPO:-nicy-luau/nicyrtdyn}"
FORCE="${FORCE:-0}"

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
  if [[ -z "$data" || "$data" == "[]" ]]; then
    echo "Nenhuma release encontrada em $repo" >&2
    exit 1
  fi
  printf '%s' "$data" | sed -n '1p'
}

extract_tag() {
  local json="$1"
  local tag
  tag="$(printf '%s' "$json" | tr -d '\n' | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')"
  if [[ -z "$tag" || "$tag" == "$json" ]]; then
    echo "Falha ao ler tag da release" >&2
    exit 1
  fi
  printf '%s' "$tag"
}

asset_url_from_release_json() {
  local json="$1"
  local asset_name="$2"
  local one_line escaped_name url
  escaped_name="$(printf '%s' "$asset_name" | sed -E 's/[][(){}.+*?^$|\\/]/\\&/g')"
  one_line="$(printf '%s' "$json" | tr -d '\n')"
  url="$(printf '%s' "$one_line" | grep -Eo "\"name\":\"$escaped_name\"[^}]*\"browser_download_url\":\"[^\"]+\"" | head -n1 | sed -E 's/.*"browser_download_url":"([^"]+)".*/\1/' || true)"
  [[ -n "$url" ]] && printf '%s' "$url"
}

download_asset() {
  local url="$1"
  local out="$2"
  curl -fL -H "User-Agent: nicy-installer" "$url" -o "$out"
}

detect_platform_target() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"

  if [[ -n "${TERMUX_VERSION:-}" || "$(uname -o 2>/dev/null || true)" == "Android" ]]; then
    case "$arch" in
      aarch64|arm64) echo "android-arm" ;;
      armv7l|armv8l) echo "android-v7" ;;
      *) echo "Arquitetura Android nao suportada: $arch" >&2; exit 1 ;;
    esac
    return 0
  fi

  case "$os" in
    Linux)
      case "$arch" in
        x86_64|amd64) echo "linux-x64" ;;
        aarch64|arm64) echo "linux-arm" ;;
        i686|i386) echo "linux-x86" ;;
        *) echo "Arquitetura Linux nao suportada: $arch" >&2; exit 1 ;;
      esac
      ;;
    Darwin)
      case "$arch" in
        x86_64|amd64) echo "mac-x64" ;;
        arm64|aarch64) echo "mac-arm" ;;
        *) echo "Arquitetura macOS nao suportada: $arch" >&2; exit 1 ;;
      esac
      ;;
    *)
      echo "Sistema nao suportado: $os" >&2
      exit 1
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
    if ! grep -Fq "$install_root" "$rc"; then
      printf '\n%s\n' "$line" >> "$rc"
    fi
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
  local target install_root tmp_root dl_dir ex_dir
  local nicy_release_json rt_release_json nicy_tag rt_tag
  local nicy_zip rt_zip nicy_url rt_url
  local nicy_asset runtime_asset runtime_file

  target="$(detect_platform_target)"
  if [[ -n "${PREFIX:-}" && ( -n "${TERMUX_VERSION:-}" || "$(uname -o 2>/dev/null || true)" == "Android" ) ]]; then
    install_root="${INSTALL_ROOT:-$PREFIX/opt/nicy/bin}"
  else
    install_root="${INSTALL_ROOT:-$HOME/.local/Nicy/bin}"
  fi

  tmp_root="$(mktemp -d)"
  dl_dir="$tmp_root/downloads"
  ex_dir="$tmp_root/extract"
  mkdir -p "$dl_dir" "$ex_dir" "$install_root"

  trap 'rm -rf "$tmp_root"' EXIT

  nicy_release_json="$(latest_release_json "$NICY_REPO")"
  rt_release_json="$(latest_release_json "$RUNTIME_REPO")"
  nicy_tag="$(extract_tag "$nicy_release_json")"
  rt_tag="$(extract_tag "$rt_release_json")"

  nicy_asset="nicy-$target.zip"
  runtime_asset="nicyrtdyn-$target.zip"

  nicy_url="$(asset_url_from_release_json "$nicy_release_json" "$nicy_asset")"
  rt_url="$(asset_url_from_release_json "$rt_release_json" "$runtime_asset")"

  if [[ -z "$nicy_url" ]]; then
    echo "Asset nao encontrado: $nicy_asset (repo $NICY_REPO tag $nicy_tag)" >&2
    exit 1
  fi
  if [[ -z "$rt_url" ]]; then
    echo "Asset nao encontrado: $runtime_asset (repo $RUNTIME_REPO tag $rt_tag)" >&2
    exit 1
  fi

  nicy_zip="$dl_dir/nicy.zip"
  rt_zip="$dl_dir/runtime.zip"

  download_asset "$nicy_url" "$nicy_zip"
  download_asset "$rt_url" "$rt_zip"

  unzip -oq "$nicy_zip" -d "$ex_dir/nicy"
  unzip -oq "$rt_zip" -d "$ex_dir/runtime"

  cp -f "$(find "$ex_dir/nicy" -type f -name "nicy" | head -n1)" "$install_root/nicy"
  chmod +x "$install_root/nicy"

  runtime_file="$(runtime_filename_for_target "$target")"
  cp -f "$(find "$ex_dir/runtime" -type f -name "$runtime_file" | head -n1)" "$install_root/$runtime_file"

  if [[ "${FORCE}" == "1" || "${FORCE}" == "true" ]]; then
    true
  fi

  ensure_path_persisted "$install_root"

  if "$install_root/nicy" runtime-version >/dev/null 2>&1; then
    :
  else
    echo "Aviso: nicy instalado, mas runtime-version falhou no teste rapido." >&2
  fi

  echo "Instalacao concluida"
  echo "Nicy: $install_root/nicy"
  echo "Runtime: $install_root/$runtime_file"
  echo "Target: $target"
  echo "Nicy release: $nicy_tag"
  echo "Runtime release: $rt_tag"
  echo "Nicy asset: $nicy_asset"
  echo "Runtime asset: $runtime_asset"
  echo "PATH atualizado com: $install_root"
}

main "$@"

