#! /usr/bin/env bash
# TODO -- improve this so it works more generally, needs to set the value for multiple targets.

echo -en "copy\nfile://$AWMAN_CURRENT_FILE" | xclip -i -selection clipboard -t x-special/mate-copied-files
