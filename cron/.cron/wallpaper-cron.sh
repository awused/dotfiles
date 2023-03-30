#! /bin/sh
# Runs wallpapers random if the session is unlocked and if mpv is not playing.
# Connects to the first session owned by the current user if DISPLAY is not set.

lockname='i3lock'

mpvsocket='/tmp/mpvsocket'

# In case you're using https://github.com/wis/mpvSockets or similar.
mpv_glob='/tmp/mpv-sockets/*'

#############

pidof "$lockname" > /dev/null && exit 0

if [ -S "$mpvsocket" ]; then
  paused=$(echo '{ "command": ["get_property", "pause"] }' | nc -UN "$mpvsocket" 2>/dev/null | jq '.data')
  [ "$paused" = "false" ] && exit 0
fi

for sock in $mpv_glob; do
  if [ -S "$sock" ]; then
    paused=$(echo '{ "command": ["get_property", "pause"] }' | nc -UN "$sock" 2>/dev/null | jq '.data')
    [ "$paused" = "false" ] && exit 0
  fi
done

if [ -z "$DISPLAY" ]; then
  export DISPLAY=$(ps e ww -u "$USER" | sed -rn 's/.* DISPLAY=(:[0-9]+).*/\1/p' | sort | uniq | head -n 1)
fi

wallpapers random
