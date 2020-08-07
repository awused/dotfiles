#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

echo $title | grep -E ' - ReadJUMP - Mozilla Firefox"$' > /dev/null

beginning=$(echo $title | grep -b -o ' of ' | cut -d: -f1 | head -n1)
title=${title:($beginning + 4)}

end=$(echo $title | grep -b -o ' - ReadJUMP ' | cut -d: -f1 | head -n1)

title=${title:0:$end}

[ -z "$title" ] && exit 1

echo "manga"
echo "$title"
