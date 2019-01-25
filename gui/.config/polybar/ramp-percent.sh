#!/bin/sh

ramp=(▂ ▃ ▄ ▅ ▆ ▇ █ █ █)
index=$(expr $1 \* 8 / 100)

echo ${ramp[$index]}$(printf '%2s' $1)%

