#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

echo $title | grep -E ' - 100 Kanojo Manga (-|—) Mozilla Firefox"$' > /dev/null

title="The 100 Girlfriends Who Really, Really, Really, Really, Really Love You"

[ -z "$title" ] && exit 1

echo "manga"
echo "$title"
