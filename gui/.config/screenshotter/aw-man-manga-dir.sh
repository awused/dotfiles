#!/bin/sh

set -e

status=$(echo "status" | nc -U "/tmp/aw-man${SCREENSHOTTER_PID}.sock")
path=$(echo "$status" | jq ".AWMAN_ARCHIVE" | grep -E '"/storage/media/manga/[^/]+($|/[^/]+\.[a-z]{3})"')
dir=$(echo "$path" | sed -E 's/^.*\/manga\/([^/]+)($|\/[^/]+\.[a-z]{3}"$)/\1/' | sed -E 's/ - [a-zA-Z0-9_-]+$//')

[[ -z "$dir" ]] && exit 1

echo "manga"
echo "$dir"

