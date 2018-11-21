#! /usr/bin/env bash

cd "$1"

for dir in "${@:2}"; do
  reldir=$(realpath --relative-to="$1" "$dir")
  zip -r "$reldir" "$reldir" || notify-send "Failed to zip" "$reldir"
done

notify-send "Done archiving"
