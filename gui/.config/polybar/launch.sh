#!/bin/sh

killall -q polybar

for m in $(polybar --list-monitors | cut -d":" -f1); do
 MONITOR=$m polybar primary &
done
