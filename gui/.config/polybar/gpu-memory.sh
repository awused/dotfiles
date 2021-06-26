#! /usr/bin/env bash


q=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk '{ print ""$1"/"$2""}' | sed 's/,//')

used=$(echo "scale=1; $q/1000" | sed 's/\/.*\//\//' | bc)
percent=$(echo "100*$q" | bc)

ramp=(▂ ▃ ▄ ▅ ▆ ▇ █ █ █)
index=$(expr $percent \* 8 / 100)

echo ${ramp[$index]}$(printf '%2s' $used) GiB

