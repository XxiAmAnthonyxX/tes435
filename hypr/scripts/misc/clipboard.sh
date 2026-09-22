#!/usr/bin/env bash
# Clipboard history with clean image previews (cliphist + fzf + kitten icat)

selected=$(
  cliphist list | fzf \
    --no-sort \
    --delimiter=$'\t' \
    --with-nth=2 \
    --preview '
      bash -c "
        id=\"{1}\"
        mime=\$(cliphist decode \"\$id\" 2>/dev/null | file -b --mime-type -)

        # Always clear previous image first
        kitten icat --clear --transfer-mode=memory >/dev/null 2>&1

        if [[ \$mime == image/* ]]; then
          tmp=\$(mktemp --suffix=.png)
          cliphist decode \"\$id\" > \"\$tmp\"
          kitten icat --clear --stdin=no --transfer-mode=memory \
            --place=\"\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0\" \"\$tmp\"
          rm -f \"\$tmp\"
        else
          cliphist decode \"\$id\" | bat --color=always --style=numbers --paging=never
        fi
      "
    '
)

[[ -z $selected ]] && exit 0

echo "$selected" | cliphist decode | wl-copy
