#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

echo $title | grep -E 'ptscans\.com (-|—) Mozilla Firefox"$' > /dev/null

beginning=$(echo $title | grep -b -o '= "' | cut -d: -f1 | head -n1)
fulltitle=${title:($beginning + 3)}

title=${fulltitle%% :: *}

[ -z "$title" ] && exit 1

# Exclude a few pages I might actually use
# Don't try to be exhaustive

echo "manga"
echo "$title"
