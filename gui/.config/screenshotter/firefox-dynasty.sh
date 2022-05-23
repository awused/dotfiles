#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

echo $title | grep -E '"Dynasty Reader » .* (-|—) Mozilla Firefox"$' > /dev/null

beginning=$(echo $title | grep -b -o '= "' | cut -d: -f1 | head -n1)
fulltitle=${title:($beginning + 20)}

# Naively assume manga won't have hyphenated titles with hyphens surrounded by
# spaces. This will be wrong at times but can be manually overridden
title=$(echo $fulltitle | sed -E 's/ (ch[0-9]+ )?(-|—) Mozilla Firefox"$//')

[ -z "$title" ] && exit 1

echo "manga"
echo "$title"
