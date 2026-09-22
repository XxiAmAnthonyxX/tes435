#!/bin/bash

WALLDIR="${WALLDIR:-$HOME/.config/hypr/scripts/theme/wallpapers/}"
LOCKIMG="$HOME/.config/hypr/scripts/theme/cache/hyprlock_wallpaper.png"
THUMB_CACHE="$HOME/.config/hypr/scripts/theme/cache/"
mkdir -p "$THUMB_CACHE"
source "$HOME/.config/hypr/scripts/fzf-colors.sh"

make_thumb() {
  local file="$1"
  local hash
  hash=$(printf '%s' "$file" | md5sum | cut -d' ' -f1)
  local cache="$THUMB_CACHE/${hash}.jpg"

  if [[ ! -f "$cache" || "$file" -nt "$cache" ]]; then
    if command -v ffmpegthumbnailer >/dev/null 2>&1; then
      ffmpegthumbnailer -i "$file" -o "$cache" -s 480 -q 6 -t 10% 2>/dev/null
    else
      ffmpeg -y -ss 00:00:01 -i "$file" \
        -frames:v 1 -an \
        -vf "scale=480:-1:flags=fast_bilinear" \
        -q:v 6 \
        "$cache" >/dev/null 2>&1
    fi
  fi
  printf '%s' "$cache"
}
export -f make_thumb
export THUMB_CACHE

mapfile -t ENTRIES < <(
  find "$WALLDIR" -type f \( \
    -iname '*.gif' -o -iname '*.mp4' -o -iname '*.webm' -o -iname '*.mkv' \
    \) -print 2>/dev/null | sort | while read -r f; do
    printf '%s\t%s\n' "$(basename "$f")" "$f"
  done
)

COUNT=${#ENTRIES[@]}
[[ $COUNT -eq 0 ]] && {
  echo "No wallpapers found in $WALLDIR"
  exit 1
}

selected=$(
  printf '%s\n' "${ENTRIES[@]}" | fzf \
    --delimiter=$'\t' \
    --with-nth=1 \
    --preview '
      file=$(echo {} | cut -f2-)
      thumb=$(make_thumb "$file")
      if [[ -f "$thumb" ]]; then
        kitty +kitten icat --clear --stdin=no --transfer-mode=memory --place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" "$thumb"
      else
        echo "preview unavailable"
      fi
    '
)

[[ -z "$selected" ]] && exit 0

selected=$(echo "$selected" | cut -f2-)

ffmpeg -y -ss 00:00:01 -i "$selected" -frames:v 1 -q:v 2 "$LOCKIMG" >/dev/null 2>&1

if pgrep -x mpvpaper >/dev/null; then
  pkill -9 mpvpaper
  sleep 0.3
fi

wal --cols16 -i "$selected" -n
pkill -SIGUSR1 kitty 2>/dev/null || true
command -v pywalfox >/dev/null && pywalfox update

COMMON_OPTS="loop panscan=1.0 no-audio hwdec=auto-safe profile=fast vf=fps=30 scale=bilinear cscale=bilinear dscale=bilinear deband=no interpolation=no"

setsid mpvpaper -o "$COMMON_OPTS" DP-1 "$selected" >/dev/null 2>&1 &
setsid mpvpaper -o "$COMMON_OPTS" HDMI-A-1 "$selected" >/dev/null 2>&1 &
