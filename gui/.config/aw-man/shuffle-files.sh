#! /bin/sh
# Could make this use aw-shuffle, but probably not worth it

set -e

echo "$AWMAN_PAGE_COUNT"

if [ -z "$AWMAN_PAGE_COUNT" ]; then
  exit 1
fi

target=$(shuf -i 1-"$AWMAN_PAGE_COUNT" -n 1)

echo "Jump $target"
