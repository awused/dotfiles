#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

echo $title | grep -E '\| MANGA Plus - Mozilla Firefox"$' > /dev/null

beginning=$(echo $title | grep -b -o ']' | cut -d: -f1 | head -n1)
title=${title:($beginning + 2)}

end=$(echo $title | grep -b -o ' [|] MANGA Plus ' | cut -d: -f1 | head -n1)

title=${title:0:$end}

[ -z "$title" ] && exit 1

echo "manga"
echo "$title"
