#!/bin/sh

set -e

cmd=$(ps -ww -o cmd --pid $SCREENSHOTTER_PID | grep -E "/storage/media/manga/[^/]+($|/[^/]+\.zip)")
dir=$(echo "$cmd" | sed -E 's/^.*\/manga\/([^/]+)($|\/[^/]+\.zip$)/\1/' | sed -E 's/ - [a-zA-Z0-9_-]+$//')

[[ -z "$dir" ]] && exit 1

echo "manga"
echo "$dir"

