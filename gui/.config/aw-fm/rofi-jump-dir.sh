#! /usr/bin/env bash

# Opens rofi, selects one or multiple files or directories, then navigates or opens new tabs.

root=$1
type=$2

target=$(
  sh -c "bfs -L $FZF_EXCLUDES $type \"$root\" -maxdepth 4" | \
      sed "s?${root}/??" | \
      tail -n +2 | \
      rofi -dmenu -i -multi-select -ballot-unselected-str ' ' -ballot-selected-str '>'
)

[ -n "$target" ] || exit 0

lines=$(echo "$target" | wc -l)
if [ "$lines" = "1" ]; then
  echo "Navigate $root/$target"
else
  # Reverse the list because new tabs open below the current tab

  while IFS= read -r line; do
    echo "NewBackgroundTab $root/$line"
  done < <(echo "$target" | tac)
fi

