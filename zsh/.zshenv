# ~/.zshenv
# These don't change often, so no auto-sourcing
# vim: set foldmethod=marker foldlevel=0:

umask 002

export EDITOR='vim'
export PAGER='less'
export LANG=en_US.UTF-8
# https://geoff.greer.fm/lscolors/
export LSCOLORS=ExGxdxdxCxDxDxBxBxegeg
export LS_COLORS='di=1;34:ln=1;36:so=33:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=34;46:ow=34;46'
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN
export PYTHONIOENCODING=UTF-8

export SOURCE_DIR=/storage/media/src
export THIRD_PARTY_SOURCE=$SOURCE_DIR/third_party
export GOPATH=$SOURCE_DIR/go

# Set TIME_STYLE for GNU coreutils
export TIME_STYLE="long-iso"


#{{{ OS/Computer specific settings
if [[ $(hostname) == 'desutop' ]]; then
  export CFLAGS="-march=native -O2 -pipe"
  export CXXFLAGS="$CFLAGS"
  export MAKEFLAGS="-j32"
fi
#}}}

