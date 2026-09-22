#!/bin/bash

cp ~/.config/hypr/scripts/background/blur/decoration.lua ~/.config/hypr/config/decoration.lua
cp ~/.config/hypr/scripts/background/blur/layerrules.lua ~/.config/hypr/system/layerrules.lua
cp ~/.config/waybar/backgrounds/transparent.css ~/.config/waybar/style.css
cp ~/.config/hypr/scripts/background/blur/kitty.conf ~/.config/kitty

if pgrep -x waybar >/dev/null; then
  pkill -SIGUSR2 -x waybar
else
  waybar >/tmp/waybar.log 2>&1 &
fi
