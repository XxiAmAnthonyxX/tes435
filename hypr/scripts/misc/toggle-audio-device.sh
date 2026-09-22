#!/bin/bash

SPEAKERS="alsa_output.pci-0000_03_00.1.hdmi-stereo"
EARBUDS="alsa_output.pci-0000_0f_00.6.analog-stereo"
CURRENT=$(pactl get-default-sink)

if [ "$CURRENT" = "$SPEAKERS" ]; then
  pactl set-default-sink "$EARBUDS"
else
  pactl set-default-sink "$SPEAKERS"
fi
