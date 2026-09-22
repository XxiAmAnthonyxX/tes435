#!/bin/bash

WALLDIR="${WALLDIR:-$HOME/.config/hypr/scripts/theme/wallpapers/}"
LOCKIMG="$HOME/.config/hypr/scripts/theme/cache/hyprlock_wallpaper.png"
CACHE_DIR="$HOME/.config/hypr/scripts/theme/cache/"
CURRENT_WALLPAPER="$CACHE_DIR/current_wallpaper"
mkdir -p "$CACHE_DIR"

mapfile -t WALLPAPERS < <(
  find "$WALLDIR" -type f \( \
    -iname '*.gif' -o -iname '*.mp4' -o -iname '*.webm' -o -iname '*.mkv' \
    \) -print 2>/dev/null
)

COUNT=${#WALLPAPERS[@]}
[[ $COUNT -eq 0 ]] && {
  echo "No wallpapers found in $WALLDIR"
  exit 1
}

PREVIOUS=""
[[ -f "$CURRENT_WALLPAPER" ]] && PREVIOUS=$(<"$CURRENT_WALLPAPER")

if [[ $COUNT -eq 1 ]]; then
  selected="${WALLPAPERS[0]}"
else
  while :; do
    selected="${WALLPAPERS[RANDOM % COUNT]}"
    [[ "$selected" != "$PREVIOUS" ]] && break
  done
fi

printf '%s\n' "$selected" >"$CURRENT_WALLPAPER"

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
