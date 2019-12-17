#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID _NET_WM_NAME)

beginning=$(echo $title | grep -b -o '= "' | cut -d: -f1 | head -n1)
title=${title:($beginning + 3)}

match=$(echo $title | grep -Poi '^(\[[^]]+\] )?\K(.*)(?=( - [0-9]{2,})|( [e][0-9]{2,})|( - episode [0-9]+)|( [0-9]{2,} - mpv))')
#match=$(echo $title | grep -Po '^\[[^]]+\] \K(.*)(?= - [0-9]{2,})()')

echo "anime"
echo "$match"

