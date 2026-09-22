#!/bin/bash
SCRIPT_DIR="$HOME/.config/hypr/scripts"

source "$SCRIPT_DIR/fzf-colors.sh"

selected=$(
  find "$SCRIPT_DIR" -type f -name '*.sh' -executable -printf '%f\t%P\n' 2>/dev/null |
    fzf \
      --delimiter=$'\t' \
      --with-nth=1 \
      --preview "bat --color=always --style=numbers --line-range=:500 -- \"$SCRIPT_DIR\"/{2}"
)

[[ -z "$selected" ]] && exit 0

relpath="${selected#*$'\t'}"
"$SCRIPT_DIR/$relpath"
