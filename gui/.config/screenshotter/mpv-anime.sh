#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

title=${title:19}

match=$(echo $title | grep -Po '^\[[^]]+\] \K(.*)(?= - [0-9]{2,})')

echo "anime"
echo "$match"

