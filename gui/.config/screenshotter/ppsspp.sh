#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID _NET_WM_NAME)

echo $title | grep -E '"PPSSPP' > /dev/null

beginning=$(echo $title | grep -b -o '= "' | cut -d: -f1 | head -n1)
title=${title:($beginning + 3)}

title=${title#* : }
title=${title%\"*}

[ -z "$title" ] && exit 1

echo "$title"
