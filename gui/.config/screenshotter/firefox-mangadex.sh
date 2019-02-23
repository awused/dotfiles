#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

echo $title | grep -E 'MangaDex - Mozilla Firefox"$' > /dev/null

title=${title:19}

# Naively assume manga won't have hyphenated titles with hyphens surrounded by
# spaces. This will be wrong at times but can be manually overridden
end=$(echo $title | grep -b -o ' - ' | cut -d: -f1 | head -n1)

title=${title:0:$end}

[ -z "$title" ] && exit 1

echo "manga"
echo "$title"
