#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_ICON_NAME)

beginning=$(echo $title | grep -b -o '\]' | cut -d: -f1 | head -n1)
title=${title:($beginning + 1)}

match=$(echo $title | grep -Poi '^(\[[^]]+\] )?\K(.*)(?=( (v|c)[0-9]+))')

echo "manga"
echo "$match"

