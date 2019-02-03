#! /usr/bin/env bash


for dir in "$@"; do
  base=$(basename "$dir")

  cd "$dir"

  zip -r "../${base}.zip" "." || notify-send "Failed to zip" "$base"
done

notify-send "Done archiving"
