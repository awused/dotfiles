#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

[[ "$title" = "Holocure" ]] && echo "holocure" && exit 0

exit 1
