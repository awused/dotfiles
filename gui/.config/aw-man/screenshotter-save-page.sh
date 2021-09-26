#! /bin/sh
# A basic script to save the current page as a file using zenity.
# Remembers the previous directory used.

# You may want to edit this.
prevdirfile="$HOME/.config/aw-man/.save-page-dir"

set -e

# It's important to set the clipboard to something to avoid the case where the user reflexively
# pastes it after assuming something overwrote the clipboard's contents.
# This avoids pasting anything sensitive.
echo "error" | xsel --input --clipboard

src="$AWMAN_CURRENT_FILE"
dst=$(screenshotter window-name "$AWMAN_WINDOW")

if [ ! -f "$src" ]; then
  echo "No current file"
  exit 1
fi

if [ -f "$dst" ]; then
  echo "Destination file exists"
  exit 1
fi

mkdir -p "$(dirname "$dst")" -m 0775

mime=$(file -b --mime-type "$src")
if [ "$mime" = "image/png" ]; then
  cp "$src" "$dst"
else
  vips pngsave "$src" "$dst" --compression 9
fi

chmod 664 "$dst"

public-clipboard "$dst"
