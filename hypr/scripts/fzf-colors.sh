#!/bin/bash

source "${HOME}/.cache/wal/colors.sh"

export FZF_DEFAULT_OPTS="
  --color=fg:${foreground},bg:${background},hl:${color14}
  --color=fg+:${foreground},bg+:${color0},hl+:${color11}
  --color=info:${color6},prompt:${color14},pointer:${color14}
  --color=marker:${color14},spinner:${color9},header:${color11}
  --color=border:${color8}
  --color=preview-fg:${foreground},preview-bg:${background}
  --layout=reverse
  --border=rounded
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
  --info=inline
  --height=100%
  --preview-window='right:50%:wrap:border-rounded'
  --bind='ctrl-/:toggle-preview'
"

export BAT_THEME="ansi"
