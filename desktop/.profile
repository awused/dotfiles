# ~/.profile
# LOG="$HOME/profile-invocations"
# echo "-----" >>$LOG
# echo "Caller: $0" >>$LOG
# echo "DESKTOP_SESSION: $DESKTOP_SESSION" >>$LOG
# echo "GDMSESSION: $GDMSESSION" >>$LOG

if [ "$0" = "/etc/X11/xinit/Xsession" -a "$DESKTOP_SESSION" = "i3" ]; then
  export GTK_IM_MODULE=xim
  export XMODIFIERS=@im=ibus
  export QT_IM_MODULE=xim
  # For kitty, but kitty handles IME input very poorly
  # Better off using xfce4-terminal when I need this
  export GLFW_IM_MODULE=ibus
fi

export WLR_NO_HARDWARE_CURSORS=1
