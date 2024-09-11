#!/bin/sh

lockname='i3lock'

pidof "$lockname" > /dev/null && exit 0

nvidia-smi -i 0 --query-gpu=$1 --format=csv,noheader,nounits | head -n1 | awk '{ print ""$1""}'


