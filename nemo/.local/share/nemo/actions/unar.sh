#!/bin/sh

dir=$(dirname "$1")

unar -o "$dir" "$1" && notify-send done "$1"

