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
mapfile -t selected < <(
  pacman -Qq | fzf \
    --multi \
    --layout=reverse \
    --border=rounded \
    --height=90% \
    --prompt='❯ Uninstall › ' \
    --pointer='▶' \
    --marker='✓' \
    --preview '
      echo -e "\033[1;36mPackage info:\033[0m"
      pacman -Qi {} 2>/dev/null || echo "Package not found"
    ' \
    --preview-window='right:55%:wrap:border-rounded'
)

((${#selected[@]} == 0)) && exit 0

# ── Calculate what will be removed ───────────────────────────────────────────
# Note: -n (--nosave) cannot be combined with --print
mapfile -t to_remove < <(
  pacman -Rs --print --print-format "%n" -- "${selected[@]}" 2>/dev/null || true
)

declare -A selected_map
for pkg in "${selected[@]}"; do
  selected_map["$pkg"]=1
done

explicit=()
deps=()

for pkg in "${to_remove[@]}"; do
  [[ -z "$pkg" ]] && continue
  if [[ -n "${selected_map[$pkg]:-}" ]]; then
    explicit+=("$pkg")
  else
    deps+=("$pkg")
  fi
done

((${#explicit[@]} == 0)) && explicit=("${selected[@]}")

# ── Optional: calculate total size ───────────────────────────────────────────
total_size=0
if ((${#to_remove[@]} > 0)); then
  while read -r size; do
    total_size=$((total_size + size))
  done < <(pacman -Qi -- "${to_remove[@]}" 2>/dev/null | awk '/^Installed Size/ {print $4}' | sed 's/[^0-9.]//g')
fi

# Convert to human readable roughly (MiB)
size_mib=$(awk -v s="$total_size" 'BEGIN { printf "%.1f", s }')

# ── Confirmation screen ──────────────────────────────────────────────────────
echo
echo -e "\033[1;36mSelected package(s):\033[0m"
printf '  • %s\n' "${explicit[@]}"

if ((${#deps[@]} > 0)); then
  echo
  echo -e "\033[1;33mUnused dependencies that will also be removed (${#deps[@]}):\033[0m"
  printf '  • %s\n' "${deps[@]}"
else
  echo
  echo -e "\033[2mNo unused dependencies will be removed.\033[0m"
fi

if ((${#to_remove[@]} > 0)); then
  echo
  echo -e "\033[1;35mTotal packages to remove: ${#to_remove[@]}  |  Approx. size: ${size_mib} MiB\033[0m"
fi

echo
read -rp "Proceed with uninstall? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || exit 0

# ── Uninstall ────────────────────────────────────────────────────────────────
echo
yay -Rns -- "${selected[@]}"
