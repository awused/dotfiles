#!/bin/sh

set -e

mogrify -gravity North -chop x27 "$1"
