#!/bin/sh

set -e

cmd=$(ps -o cmd --pid $SCREENSHOTTER_PID | grep -E "/storage/media/manga/[^/]+/[^/]+\.zip")
dir=$(echo "$cmd" | sed -E 's/^.*\/([^/]+)\/[^/]+\.zip$/\1/' | sed -E 's/ - [[:digit:]]+$//')

[[ -z "$dir" ]] && exit 1

echo "manga"
echo "$dir"

