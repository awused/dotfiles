# ~/.zshenv
# These don't change often, so no auto-sourcing
# vim: set foldmethod=marker foldlevel=0:

umask 022

if (which nvim >/dev/null 2>&1) {
  export EDITOR='nvim'
} else {
  export EDITOR='vim'
}
export PAGER='less'
export LANG=en_US.UTF-8
# Closer to matching natural sorting, but not exactly
export LC_COLLATE=C.UTF-8
# https://geoff.greer.fm/lscolors/
export LSCOLORS=ExGxdxdxCxDxDxBxBxegeg
# Would need to set in zshrc or figure out why it's getting overridden
# Default on Fedora is much better than default on FreeBSD
#export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:';
export GOBIN=$HOME/.gobin
export GO111MODULE=on
export NODE_PATH="$NODE_PATH:$HOME/.npm/lib/node_modules"
export PATH=$PATH:$GOBIN:$HOME/bin:$HOME/.npm/bin:$HOME/.local/bin
export PYTHONIOENCODING=UTF-8
export RUSTFLAGS='-C target-cpu=native'

export SOURCE_DIR=/storage/src
export THIRD_PARTY_SOURCE=$SOURCE_DIR/third_party
export AWUSED_SOURCE=$SOURCE_DIR/awused
export GOPATH=/storage/cache/go
export CARGO_TARGET_DIR=/storage/cache/rust
export NASHOME=/storage/usr/desuwa

# Set TIME_STYLE for GNU coreutils
export TIME_STYLE="long-iso"

test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

test -r $HOME/.gcloud-sdk/path.zsh.inc && . $HOME/.gcloud-sdk/path.zsh.inc > /dev/null 2> /dev/null || true



#{{{ OS/Computer specific settings
if [[ $(uname) == 'Linux' ]]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64:/usr/local/lib
  export PATH=$HOME/.bin:$PATH:$HOME/.cargo/bin
  # This needs some modifications to not be really annoying.
  # cd ~/.themes/; cp -r /usr/share/themes/Adwaita-dark .; cd Adwaita-dark/gtk-3.0;
  # gresource extract /usr/lib64/libgtk-3.so /org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css > gtk.css
  # rg-replace "backdrop " -r "backdropdisabled "
  # rg-replace "backdrop:" -r "backdropdisabled:"
  # rg-replace "backdrop," -r "backdropdisabled,"
  # echo "* { caret-color: #222222; }" >> gtk.css
  export GTK_THEME=Adwaita-dark
  # Install xdg-desktop-portal-kde and kio-extras (plus other thumbnailer support)
  # export GTK_USE_PORTAL=1
  # export QT_STYLE_OVERRIDE=Breeze-dark
fi

if [[ $(uname) == 'FreeBSD' ]]; then
  # FreeBSD's ancient ncurses
  if [[ $TERM == 'xterm-kitty' ]]; then
    export TERM='xterm-256color'
  fi
  export PATH=$PATH:$HOME/.cargo/bin
fi

if [[ $(hostname) == 'desutop' ]]; then
  export CFLAGS="-march=native -O2 -pipe"
  export CXXFLAGS="$CFLAGS"
  export MAKEFLAGS="-j32"

  export LIBVIRT_DEFAULT_URI="qemu:///system"

  export MPD_HOST=$HOME/.config/mpd/socket

  mount | grep "/mnt/GoogleDrive" > /dev/null || google-drive-ocamlfuse "/mnt/GoogleDrive"

  export JAVA_HOME=/usr/local/java/jdk1.8.0_201
  export PATH=$PATH:$JAVA_HOME/bin
fi
#}}}

