#!/bin/sh
xrandr --output DP-0 --mode 3840x2160 --rate 120 --pos 2560x1440 --primary --output HDMI-2 --mode 2560x1440 --pos 3200x0 --rate 120 --output DP-4 --mode 2560x1440 --pos 6400x2160 --rate 120 --output DP-2 --mode 2560x1440 --pos 0x2160 --rate 120 || true
