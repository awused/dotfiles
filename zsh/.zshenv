# ~/.zshenv
# These don't change often, so no auto-sourcing
# vim: set foldmethod=marker foldlevel=0:

umask 022

export EDITOR='vim'
export PAGER='less'
export LANG=en_US.UTF-8
# https://geoff.greer.fm/lscolors/
export LSCOLORS=ExGxdxdxCxDxDxBxBxegeg
# Would need to set in zshrc or figure out why it's getting overridden
# Default on Fedora is much better than default on FreeBSD
#export LS_COLORS='di=1;34:ln=1;36:so=33:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=34;46:ow=34;46'
export GOBIN=$HOME/.gobin
export NODE_PATH="$NODE_PATH:$HOME/.npm/lib/node_modules"
export PATH=$PATH:$GOBIN:$HOME/.npm/bin:$HOME/.local/bin
export PYTHONIOENCODING=UTF-8

export SOURCE_DIR=/storage/src
export THIRD_PARTY_SOURCE=$SOURCE_DIR/third_party
export GOPATH=$SOURCE_DIR/go
export NASHOME=/storage/media/users/desuwa

# Set TIME_STYLE for GNU coreutils
export TIME_STYLE="long-iso"

test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

test -r $HOME/.gcloud-sdk/path.zsh.inc && . $HOME/.gcloud-sdk/path.zsh.inc > /dev/null 2> /dev/null || true



#{{{ OS/Computer specific settings
if [[ $(uname) == 'Linux' ]]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
  export PATH=$HOME/.bin:$PATH:$HOME/.cargo/bin
  export GTK_THEME=Arc-Dark
fi

if [[ $(uname) == 'FreeBSD' ]]; then
  # FreeBSD's ancient ncurses
  if [[ $TERM == 'xterm-kitty' ]]; then
    export TERM='xterm-256color'
  fi
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

