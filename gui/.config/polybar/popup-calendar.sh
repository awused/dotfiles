#!/bin/sh
# From https://github.com/x70b1/polybar-scripts/blob/master/polybar-scripts/popup-calendar
# TODO -- Use the workspace where the mouse is, not the focused one.

YAD_WIDTH=200
YAD_HEIGHT=200
BOTTOM=true
DATE="$(date +"%a %d %H:%M")"

case "$1" in
    --popup)
        eval "$(xdotool getmouselocation --shell)"

        if [ $BOTTOM = true ]; then
            : $(( pos_y = Y - YAD_HEIGHT - 50 ))
            : $(( pos_x = X - 166 ))
        else
            : $(( pos_y = Y + 20 ))
            : $(( pos_x = X - (YAD_WIDTH / 2) ))
        fi

        yad --calendar --undecorated --fixed --close-on-unfocus --no-buttons \
            --width=$YAD_WIDTH --height=$YAD_HEIGHT --posx=$pos_x --posy=$pos_y \
            > /dev/null
        ;;
    *)
        echo "$DATE"
        ;;
esac
