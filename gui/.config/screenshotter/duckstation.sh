#!/bin/sh

set -e

title=$SCREENSHOTTER_WM_NAME


title=$(echo $title | sed 's/ (Disc [0-9]).*//')
title=$(echo $title | sed 's/ (USA).*//')

[ -z "$title" ] && exit 1

echo "ps1"
echo "$title"
