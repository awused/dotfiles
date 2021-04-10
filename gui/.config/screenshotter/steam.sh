#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_CLASS)

echo $title | grep -E '"Steam"$' > /dev/null

echo "steam"
