#!/bin/sh

set -e

title=$(xprop -id $SCREENSHOTTER_WINDOWID WM_NAME)

echo $title | grep -E 'Manga(Dex|Cat) - Mozilla Firefox"$' > /dev/null

beginning=$(echo $title | grep -b -o '= "' | cut -d: -f1 | head -n1)
title=${title:($beginning + 3)}

# Naively assume manga won't have hyphenated titles with hyphens surrounded by
# spaces. This will be wrong at times but can be manually overridden
end=$(echo $title | grep -b -o ' - ' | cut -d: -f1 | head -n1)

title=${title:0:$end}

[ -z "$title" ] && exit 1

# For series pages
end=$(echo $title | grep -b -o ' (Title)' | cut -d: -f1 | head -n1)

[ -z "$end" ] || title=${title:0:$end}

# Exclude a few pages I might actually use
# Don't try to be exhaustive
[ "$title" = "Home" ] && exit 1
echo $title | grep -v -E " \(User\)$" > /dev/null
[ "$title" = "Follows" ] && exit 1
[ "$title" = "Groups" ] && exit 1
echo $title | grep -v -E " \(Group\)$" > /dev/null

echo "manga"
echo "$title"
