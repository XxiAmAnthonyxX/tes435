#!/bin/sh
set -euo pipefail

date '+%a %b,%e %H:%M' | sed 's/ 0/ /g; s/^0//'
