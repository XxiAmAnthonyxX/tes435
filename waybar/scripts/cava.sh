#!/usr/bin/env bash
set -euo pipefail

bars=60
bar='▁▂▃▄▅▆▇█▇▆▅▄▃▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁'

dict='s/;//g'
for ((i=0;i<${#bar};i++)); do dict+=";s/$i/${bar:i:1}/g"; done

cava -p <(cat <<EOF
[general]
bars = $bars

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF
) | stdbuf -oL sed "$dict"
