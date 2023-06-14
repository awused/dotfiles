#!/bin/sh

set -e

title=$SCREENSHOTTER_WM_NAME

title=$(echo "$title" | sed -E 's/ULUS([0-9]+) : //')

[ -z "$title" ] && exit 1

echo psp
echo "$title"
