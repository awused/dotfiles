#!/bin/sh

set -e


title=""
match=""
if title=$(xprop -id $SCREENSHOTTER_WINDOWID _NET_WM_NAME) || false ; then
  beginning=$(echo $title | grep -b -o '= "' | cut -d: -f1 | head -n1)
  title=${title:($beginning + 3)}
else
  title=$SCREENSHOTTER_WM_NAME
fi

match=$(echo $title | grep -Poi '^(\[[^]]+\] )?\K(.*)(?=( - [0-9]{2,})|( [e][0-9]{2,})|( - episode [0-9]+)|( [0-9]{2,} - mpv))' || echo "")

if [ -z "$match" ]; then
  match=$(ps -p $SCREENSHOTTER_PID -o args | grep -Poi "/storage/media/anime/\K[^/]+(?=/)")
fi
#match=$(echo $title | grep -Po '^\[[^]]+\] \K(.*)(?= - [0-9]{2,})()')

echo "anime"
echo "$match"

