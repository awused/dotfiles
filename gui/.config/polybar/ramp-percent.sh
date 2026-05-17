#! /usr/bin/env bash

ramp=(▂ ▃ ▄ ▅ ▆ ▇ █ █ █)

if [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null; then
  index=$(expr $1 \* 8 / 100)

  echo ${ramp[$index]}$(printf '%2s' $1)%
else
  echo $1
fi

