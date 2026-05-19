#!/bin/sh

locks='i3lock swaylock hyprlock'

echo "$locks" | xargs -r pidof > /dev/null && echo "locked" && exit 0

nvidia-smi -i 0 --query-gpu=$1 --format=csv,noheader,nounits | head -n1 | awk '{ print ""$1""}'


