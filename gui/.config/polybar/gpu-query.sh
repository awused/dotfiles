#!/bin/sh

lockname='i3lock'
lockname2='swaylock'

pidof "$lockname" > /dev/null && echo "locked" && exit 0
pidof "$lockname2" > /dev/null && echo "locked" && exit 0

nvidia-smi -i 0 --query-gpu=$1 --format=csv,noheader,nounits | head -n1 | awk '{ print ""$1""}'


