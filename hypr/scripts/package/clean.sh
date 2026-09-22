#!/usr/bin/env bash
set -euo pipefail

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

# ── Cleanup options ──────────────────────────────────────────────────────────
options=(
  "Remove orphaned packages"
  "Clean package cache (keep installed versions)"
  "Clean package cache (remove all)"
  "Clean yay build cache"
  "Clean everything (recommended)"
)

mapfile -t selected < <(
  printf '%s\n' "${options[@]}" | fzf \
    --multi \
    --layout=reverse \
    --border=rounded \
    --height=50% \
    --prompt='❯ Clean › ' \
    --pointer='▶' \
    --marker='✓' \
    --header 'Select cleanup tasks • Tab for multi-select'
)

((${#selected[@]} == 0)) && exit 0

# ── Confirmation ─────────────────────────────────────────────────────────────
echo
echo -e "\033[1;36mSelected cleanup tasks:\033[0m"
printf '  • %s\n' "${selected[@]}"
echo
read -rp "Proceed? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || exit 0

echo

# ── Run selected tasks ───────────────────────────────────────────────────────
for task in "${selected[@]}"; do
  case "$task" in
  "Remove orphaned packages")
    echo -e "\033[1;33m→ Removing orphaned packages...\033[0m"
    yay -Yc --noconfirm || true
    ;;
  "Clean package cache (keep installed versions)")
    echo -e "\033[1;33m→ Cleaning package cache (keeping installed versions)...\033[0m"
    yay -Sc --noconfirm || true
    ;;
  "Clean package cache (remove all)")
    echo -e "\033[1;33m→ Cleaning package cache (removing everything)...\033[0m"
    yay -Scc --noconfirm || true
    ;;
  "Clean yay build cache")
    echo -e "\033[1;33m→ Cleaning yay build cache...\033[0m"
    rm -rf "${HOME}/.cache/yay/"* 2>/dev/null || true
    echo "  Done."
    ;;
  "Clean everything (recommended)")
    echo -e "\033[1;33m→ Removing orphaned packages...\033[0m"
    yay -Yc --noconfirm || true
    echo
    echo -e "\033[1;33m→ Cleaning package cache (keeping installed versions)...\033[0m"
    yay -Sc --noconfirm || true
    echo
    echo -e "\033[1;33m→ Cleaning yay build cache...\033[0m"
    rm -rf "${HOME}/.cache/yay/"* 2>/dev/null || true
    echo "  Done."
    ;;
  esac
  echo
done

echo -e "\033[1;32mCleanup finished.\033[0m"
