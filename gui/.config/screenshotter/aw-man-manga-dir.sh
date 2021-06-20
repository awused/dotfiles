#!/bin/sh

# Needs xcffib installed

set -e

pid=$(python - <<"END"
import xcffib, xcffib.xproto, xcffib.res
import os

connection = xcffib.connect()
resext = connection(xcffib.res.key)
spec = xcffib.res.ClientIdSpec.synthetic(
    int(os.getenv("SCREENSHOTTER_WINDOWID")), xcffib.res.ClientIdMask.LocalClientPID)
cookie = resext.QueryClientIds(1, [spec])
reply = cookie.reply()

print(reply.ids[0].value[0])

END
)

status=$(echo "status" | nc -U "/tmp/aw-man${pid}.sock")
path=$(echo "$status" | jq ".AWMAN_ARCHIVE" | grep -E '"/storage/media/manga/[^/]+($|/[^/]+\.[a-z]{3})"')
dir=$(echo "$path" | sed -E 's/^.*\/manga\/([^/]+)($|\/[^/]+\.[a-z]{3}"$)/\1/' | sed -E 's/ - [a-zA-Z0-9_-]+$//')

[[ -z "$dir" ]] && exit 1

echo "manga"
echo "$dir"

