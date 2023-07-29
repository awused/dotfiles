#! /bin/sh

echo $AWFM_CURRENT_TAB_PATH

[ -n "$AWFM_CURRENT_TAB_PATH" ] || exit 0

/home/desuwa/.config/aw-fm/rofi-jump-dir.sh "$AWFM_CURRENT_TAB_PATH" "-type d"
