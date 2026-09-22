#!/usr/bin/env bash
set -euo pipefail

source "$HOME/.config/hypr/scripts/fzf-colors.sh"

DIRS=(
  "$HOME/.local/share/applications"
  /usr/share/applications
  /usr/local/share/applications
  /var/lib/flatpak/exports/share/applications
  "$HOME/.local/share/flatpak/exports/share/applications"
)

choice=$(
  for dir in "${DIRS[@]}"; do
    [[ -d "$dir" ]] || continue
    find "$dir" -name '*.desktop' -type f 2>/dev/null
  done | while read -r desktop; do
    grep -qE '^(NoDisplay|Hidden)=true' "$desktop" 2>/dev/null && continue

    name=$(grep -m1 '^Name=' "$desktop" | cut -d= -f2- | tr -d '\r' || true)
    exec=$(grep -m1 '^Exec=' "$desktop" | cut -d= -f2- | tr -d '\r' || true)
    terminal=$(grep -m1 '^Terminal=' "$desktop" | cut -d= -f2- | tr -d '\r' || echo "false")
    comment=$(grep -m1 '^Comment=' "$desktop" | cut -d= -f2- | tr -d '\r' || true)

    [[ -z "$name" || -z "$exec" ]] && continue

    exec=$(echo "$exec" | sed -E 's/ %[fFuUdDnNickvm]//g' | sed 's/  */ /g' | xargs)

    printf "%s\t%s\t%s\t%s\n" "$name" "$exec" "$terminal" "${comment:-}"
  done | sort -t$'\t' -k1,1 |
    fzf --delimiter=$'\t' \
      --with-nth=1,4 \
      --preview 'echo -e "\033[1m{1}\033[0m\n\n{4}\n\n\033[2mExec: {2}\033[0m"'
)

[[ -z "$choice" ]] && exit 0

name=$(echo "$choice" | cut -f1)
cmd=$(echo "$choice" | cut -f2)
terminal=$(echo "$choice" | cut -f3)

if [[ "$terminal" == "true" ]]; then
  kitty --class terminal-app --detach -e $cmd
else
  nohup setsid $cmd >/dev/null 2>&1 &
fi
