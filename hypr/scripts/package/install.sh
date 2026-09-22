#!/usr/bin/env bash

# ── Colors (pywal or Catppuccin Mocha fallback) ──────────────────────────────
if [[ -f "${HOME}/.cache/wal/colors.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.cache/wal/colors.sh"
else
  background="#1e1e2e"
  foreground="#cdd6f4"
  color0="#1e1e2e"
  color1="#f38ba8"
  color2="#a6e3a1"
  color3="#f9e2af"
  color4="#89b4fa"
  color5="#cba6f7"
  color6="#94e2d5"
  color7="#cdd6f4"
  color8="#585b70"
fi

export FZF_DEFAULT_OPTS="
  --color=fg:${foreground},bg:${background},hl:${color4}
  --color=fg+:${foreground},bg+:${color0},hl+:${color4}
  --color=info:${color6},prompt:${color5},pointer:${color1}
  --color=marker:${color1},spinner:${color1},header:${color6}
  --color=border:${color8}
  --color=preview-fg:${foreground},preview-bg:${background}
  --color=gutter:${background}
"

# ── Select package(s) ────────────────────────────────────────────────────────
# Uses a live search approach: type to search, results update as you type
mapfile -t selected < <(
  fzf \
    --multi \
    --layout=reverse \
    --border=rounded \
    --height=90% \
    --prompt='❯ Install › ' \
    --pointer='▶' \
    --marker='✓' \
    --disabled \
    --bind 'start:reload:yay -Slq' \
    --bind 'change:reload:yay -Ss {q} 2>/dev/null | grep -E "^[a-zA-Z0-9_.+-]+/" | cut -d" " -f1 | cut -d"/" -f2 | sort -u || true' \
    --preview '
      echo -e "\033[1;36mPackage info:\033[0m"
      yay -Si {1} 2>/dev/null || echo "Could not fetch info"
    ' \
    --preview-window='right:55%:wrap:border-rounded' \
    --header 'Type to search • Tab to multi-select • Enter to confirm'
)

((${#selected[@]} == 0)) && exit 0

# ── Gather detailed info for confirmation ────────────────────────────────────
echo
echo -e "\033[1;36mGathering package information...\033[0m"

declare -a display_lines=()
total_download=0
total_installed=0

for pkg in "${selected[@]}"; do
  info=$(yay -Si "$pkg" 2>/dev/null || true)

  repo=$(echo "$info" | awk -F' : ' '/^Repository/ {print $2; exit}')
  [[ -z "$repo" ]] && repo="aur"

  # Download Size (convert everything to MiB roughly)
  down=$(echo "$info" | awk -F' : ' '/^Download Size/ {print $2; exit}')
  inst=$(echo "$info" | awk -F' : ' '/^Installed Size/ {print $2; exit}')

  # Simple size parsing (handles KiB / MiB / GiB)
  parse_size() {
    local s="$1"
    local num unit
    num=$(echo "$s" | grep -oE '[0-9.]+' | head -1)
    unit=$(echo "$s" | grep -oE '[KMGT]iB' | head -1)
    case "$unit" in
    KiB) awk -v n="$num" 'BEGIN {printf "%.2f", n/1024}' ;;
    MiB) echo "$num" ;;
    GiB) awk -v n="$num" 'BEGIN {printf "%.2f", n*1024}' ;;
    *) echo "0" ;;
    esac
  }

  down_mib=$(parse_size "$down")
  inst_mib=$(parse_size "$inst")

  total_download=$(awk -v a="$total_download" -v b="$down_mib" 'BEGIN {printf "%.2f", a+b}')
  total_installed=$(awk -v a="$total_installed" -v b="$inst_mib" 'BEGIN {printf "%.2f", a+b}')

  # Color repo vs AUR
  if [[ "$repo" == "aur" ]]; then
    repo_display="\033[1;35maur\033[0m"
  else
    repo_display="\033[1;32m$repo\033[0m"
  fi

  display_lines+=("  • $pkg  ($repo_display)  ↓ ${down_mib} MiB  |  📦 ${inst_mib} MiB")
done

# ── Confirmation screen ──────────────────────────────────────────────────────
echo
echo -e "\033[1;36mSelected package(s) to install:\033[0m"
printf '%b\n' "${display_lines[@]}"
echo
echo -e "\033[1;35mTotal: ${#selected[@]} package(s)  |  Download: ~${total_download} MiB  |  Installed: ~${total_installed} MiB\033[0m"
echo
read -rp "Proceed with installation? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || exit 0

# ── Install ──────────────────────────────────────────────────────────────────
echo
yay -S --needed -- "${selected[@]}"
