# Created by desuwa for 5.2
# ~/.zshrc
# vim: set foldmethod=marker foldlevel=0:

# Install fzf, ripgrep, and bfs
# Uses BFS for fzf, but ripgrep for fzf in vim

# zplug install, zplug update, zplug clean

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

#{{{ Auto-source
# GNU stat by default
__stat_format='-c %Y'
stat-rc() {
 echo -n $(stat $__stat_format $(readlink -f ~/.zshrc)) || '0'
}
zle -N stat-rc

precmd() {
  if (( $__zshrc_sourced != $(stat-rc) )) {
    __zshrc_sourced=$(stat-rc)
    source ~/.zshenv
    source ~/.zshrc
  }
}
#}}}

stty icrnl -ixoff -ixon
# Ignore EOF in interactive sessions
set -o ignoreeof

PROMPT="%n@%m:%~ %# "

# History
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd..:zh"
export HISTSIZE=25000
export HISTFILE=~/.zsh_history
export SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY


# Directory stack
export DIRSTACKSIZE=8
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_IGNORE_DUPS

export LINES
export COLUMNS

# Say how long a command took, if it took more than 30 seconds
export REPORTTIME=30

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# ZCalc
autoload -U zcalc

# ZMV replaces renamerx
# zmv -n for dry runs (remove from these)
# zmv -n '(?)(?).t' '$1$(($2+1)).t'
# x1.t -> x2.t
# mmv -n *.txt *
# zmv -n '(*)' '${(Lc)1/ /-}'
# AbC Def -> abc-def
autoload -U zmv

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Quote URLs automatically
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -U url-quote-magic
zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='
zle -N self-insert url-quote-magic


# {{{ Aliases
alias j='jobs -l'
alias cp='cp -i'
alias mv='mv -i'
alias pd='popd'
#alias ls='ls -G'
alias la='ls -aF'
alias lf='ls -F'
alias ll='ls -laFh'
alias lv='exa -lFiHhg --time-style=long-iso'
alias lva='exa -lFiHhag --time-style=long-iso'
alias tree='exa -Ta -L'
alias treel='exa -Tal --time-style=long-iso -L'
alias caja='caja "$(pwd)"'
alias sgrep='/usr/bin/lv -g -Is -'
alias ng='npm run-script ng --'
alias ngserve='ng serve'
alias ngprod='npm run prod'
alias ydl='yt-dlp --write-thumbnail --write-description'
alias ydls='yt-dlp --write-sub --write-thumbnail --write-description'

_YT_FORMAT="%(title).205B-%(id)s.%(ext)s"

alias ytv='yt-dlp --no-mtime --output "/storage/usr/desuwa/Videos/${_YT_FORMAT}" --'
alias ytvs='yt-dlp --write-sub --no-mtime --output "/storage/usr/desuwa/Videos/${_YT_FORMAT}" --'
alias vt='yt-dlp --no-mtime --output "/storage/media/youtube/vtubers/${_YT_FORMAT}" --'
alias vts='yt-dlp --write-sub --no-mtime --output "/storage/media/youtube/vtubers/${_YT_FORMAT}" --'
alias ya='youtube-audio'
alias sqlite3='sqlite3-history'
# Only for debug mode
alias cbuild='mold -run cargo build'
alias crun='mold -run cargo run'
alias ctest='RUST_BACKTRACE=1 mold -run cargo test'
alias cnbuild='mold -run cargo +nightly build'
alias cnrun='mold -run cargo +nightly run'
alias cntest='RUST_BACKTRACE=1 mold -run cargo +nightly test'

alias mux='tmuxinator'
alias tm='tmux attach -d -t main'

alias mmv='noglob zmv -W'
if (which nvim >/dev/null 2>&1) {
  alias vim=nvim
}

# vim with X11 clipboard and a bunch of other bloat
#if [[ $(command -v vimx) != "" ]] {
#  alias vim='vimx'
#}

# Typing errors...
alias 'cd..=cd ..'
# }}}
#{{{ OS/Computer specific settings
if [[ $(uname) == 'FreeBSD' ]]; then
  alias date='date +"%Y-%m-%d %H:%M:%S"'
  alias ls='ls -G -D "%Y-%m-%d %H:%M:%S"'
  # alias ngserve='ng serve --host 192.168.44.2 --disable-host-check'

  __stat_format='-f %m'

  alias cutleaves='sudo pkg_cutleaves -Rxg'

  # cdp to jump to ports dir
  cdp() {
   cd $(whereis -qs $1)
  }
  zle -N cdp

  # Recursively list unmet port dependencies without installing them
  # Not the most efficient implementation, but good enough
  _unmet_port_depends() {
    echo "$(make all-depends-list | cut -f 4- -d /)" | while read dep; do
      local met=$(pkg query %n $dep)
      [ -n "$met" ] && continue
      echo $dep
    done
  }
  unmet-port-depends() {
    [ -z "$(pkg rquery %n $1)" ] && echo "Invalid port name" && return
    cdp $1
    _unmet_port_depends | awk '!a[$0]++'
  }
  zle -N unmet-port-depends

  # Reorder path so installed ports are preferred over the base system
  # This fixes tput complaining when ncurses is installed
  export PATH=$HOME/bin:/usr/local/bin:$PATH:$GOBIN

  export MPD_HOST=/storage/mpd/.mpd/socket

  if [[ $TERM = "tmux-256color" ]] {
    # Work around FreeBSD\'s ancient base system ncurses
    export TERM="screen-256color"
  }
fi

if [[ $(hostname) == 'desutop' ]]; then
  alias rd="random-doujin"
  alias ru="random-unsorted"

  function _accept-line-with-url {
    if [[ $BUFFER =~ ^https://gelbooru.com/ ]]; then
      # echo $BUFFER >> $HISTFILE
      fc -R

      BUFFERz=" gdl $BUFFER"
      zle .kill-whole-line
      BUFFER=$BUFFERz
      zle .accept-line
      # zle reset-prompt
    elif [[ $BUFFER =~ ^https://yande.re/ ]]; then
      fc -R

      BUFFERz=" yandl $BUFFER"
      zle .kill-whole-line
      BUFFER=$BUFFERz
      zle .accept-line
    elif [[ $BUFFER =~ ^https://exhentai.org/ ]]; then
      fc -R

      BUFFERz=" pdl $BUFFER"
      zle .kill-whole-line
      BUFFER=$BUFFERz
      zle .accept-line
    else
      zle .accept-line
    fi
  }

 zle -N accept-line _accept-line-with-url
fi
#}}}
#{{{ Fix Keybinds
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

autoload -U history-search-end
zle -N history-beginning-search-forward-end history-search-end
zle -N history-beginning-search-backward-end history-search-end

# History searching
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

# Fix weird broken keybinds
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Override some vi keybinds with emacs keybinds
bindkey "^H" backward-delete-char
bindkey "^V" quoted-insert
bindkey "^W" backward-kill-word
bindkey "^[OC" forward-char
bindkey "^[OD" backward-char
bindkey "^[[C" forward-char
bindkey "^[[D" backward-char
bindkey "^?" backward-delete-char
#}}}
#{{{ Automation Passwords
get-automation-password() {
  [[ $#@ -eq 1 ]] || echo "Must supply exactly one account name"
  echo -n "$(pass "$1" 2> /dev/null)"
}
zle -N get-automation-password

set-automation-password() {
  [[ $#@ -eq 2 ]] || echo "Must supply exactly two arguments"
  echo $2 | pass insert -fm $1 >/dev/null 2>&1
  return $?
}
zle -N set-automation-password

__print-subdomains() {
  echo "$(get-automation-password subdomains)" 2>/dev/null | while read item; do
    [[ ! -z $item ]] && echo "${(q)item}"
  done
  echo -n "${(q)1}"
}

__print-subdomains-except() {
  olditem=""
  echo "$(get-automation-password subdomains)" 2>/dev/null | while read item; do
    [[ -z "$item" ]] && continue
    [[ "$1" == "$item" ]] && continue
    [[ -n "$olditem" ]] && echo ""
    echo -n "${(q)item}"
    olditem=$item
  done
}

# TODO -- could pull this from nginx config files
add-subdomain() {
  [[ $#@ -eq 1 ]] || echo "Must supply exactly one new subdomain"
  __print-subdomains $1 | pass insert -fm subdomains >/dev/null 2>&1
  return $?
}
zle -N add-subdomain

remove-subdomain() {
  [[ $#@ -eq 1 ]] || echo "Must supply exactly one subdomain"
  __print-subdomains-except $1 | pass insert -fm subdomains >/dev/null 2>&1
  return $?
}
zle -N remove-subdomain

alias weechat='WEECHAT_PASSPHRASE=$(get-automation-password weechat) weechat'
#}}}
#{{{ Prompt
zstyle ':prompt:shrink_path' last 2
zstyle ':prompt:shrink_path' short 1
zstyle ':prompt:shrink_path' tilde 1

__build-prompt() {
  local prompt="${USERNAME}@${HOST%%\.*}:$(shrink_path)"
  local pcount=${#prompt}
  local ccount=$COLUMNS
  if (( $pcount > $ccount - 30 )) {
    prompt+='\n'
  }
  prompt+='> '
  echo -n $prompt
}
zle -N __build-prompt

if [[ -a ~/.zsh/shrink-path.plugin.zsh ]]; then
  source ~/.zsh/shrink-path.plugin.zsh
  setopt PROMPT_SUBST

  #PROMPT='%n@%m:$(shrink_path)> '
  PROMPT='$(__build-prompt)'
fi
#}}}
#{{{ FZF
# CTRL-T - paste into cli
# CTRL-R - search history
# CTRL-P - open in vim
# CTRL-Q - open from home directory in vim
# CTRL-S - open from source directory in vim
# CTRL-D - open from user directory on NAS in vim
# ALT-CPQSD - CD into directory starting from wherever
# CTRL-ALT-PQSD - CTRL-T-alikes
# fkill {signal} - kill processes using signal, default 15 (SIGTERM)
#{{{ Overrides
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --ansi -m'
#export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --color "always" -g "!**/{.git,node_modules,vendor,.sass-cache}/*" 2> /dev/null'
#export FZF_DEFAULT_COMMAND='fd --no-ignore --type file --hidden --follow --color "always" --exclude "**/{.git,node_modules,vendor,.sass-cache}"'
export FZF_EXCLUDES=" \
  -not \( -name '.angular' -prune \) \
  -not \( -name '.cache' -prune \) \
  -not \( -name '.ccache' -prune \) \
  -not \( -name '.cargo' -prune \) \
  -not \( -name '.conda' -prune \) \
  -not \( -path '*/.config/chromium' -prune \) \
  -not \( -path '*/.config/unity3d' -prune \) \
  -not \( -name '.dbus' -prune \) \
  -not \( -name '.duplicacy-repo' -prune \) \
  -not \( -name '.fonts' -prune \) \
  -not \( -name '.foobar2000' -prune \) \
  -not \( -name '.gcloud-sdk' -prune \) \
  -not \( -name '.gem' -prune \) \
  -not \( -name '.git' -prune \) \
  -not \( -name '.gnupg' -prune \) \
  -not \( -name '.gocode' -prune \) \
  -not \( -name '.gstreamer-*' -prune \) \
  -not \( -name '.ipfs' -prune \) \
  -not \( -name '.jspm' -prune \) \
  -not \( -name '.kde' -prune \) \
  -not \( -name '.local' -prune \) \
  -not \( -name '.m2' -prune \) \
  -not \( -name '.mozc' -prune \) \
  -not \( -name '.mozilla' -prune \) \
  -not \( -name '.node-gyp' -prune \) \
  -not \( -name '.npm' -prune \) \
  -not \( -name '.nv' -prune \) \
  -not \( -name '.opam' -prune \) \
  -not \( -name '.password-store' -prune \) \
  -not \( -path '*/.purple/icons' -prune \) \
  -not \( -name '__pycache__' -prune \) \
  -not \( -name '.QtWebEngineProcess' -prune \) \
  -not \( -name '.renpy' -prune \) \
  -not \( -name '.runelite' -prune \) \
  -not \( -name '.rustup' -prune \) \
  -not \( -name '.sass-cache' -prune \) \
  -not \( -name '.steam' -prune \) \
  -not \( -name '.Superposition' -prune \) \
  -not \( -name '.sqlite-histories' -prune \) \
  -not \( -name '.TeamSpeak*' -prune \) \
  -not \( -name '.thumbnails' -prune \) \
  -not \( -name '.trackma' -prune \) \
  -not \( -name '.Trash-*' -prune \) \
  -not \( -name '.ts3client*' -prune \) \
  -not \( -name '.var' -prune \) \
  -not \( -name '.vegas' -prune \) \
  -not \( -name '.vim' -prune \) \
  -not \( -name 'vivaldi' -prune \) \
  -not \( -name '.waifu2x' -prune \) \
  -not \( -name '.wine*' -prune \) \
  -not \( -name '.zplug' -prune \) \
  -not \( -name 'dist' -prune \) \
  -not \( -name 'env' -prune \) \
  -not \( -path '*/go/pkg' -prune \) \
  -not \( -path '*/go/golang.org' -prune \) \
  -not \( -path '*/github.com/golangci' -prune \) \
  -not \( -name 'hydrus' -prune \) \
  -not \( -name 'node_modules' -prune \) \
  -not \( -name 'target' -prune \) \
  -not \( -path '*/third_party/*/*/*' -prune \) \
  -not \( -name 'Unsorted Downloads' -prune \) \
  -not \( -name 'vendor' -prune \) "

export FZF_DEFAULT_COMMAND="bfs -color -L \
  $FZF_EXCLUDES \
  -type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="bfs -color -L -type d $FZF_EXCLUDES"
FZF_BOTH_COMMAND="bfs -color -L $FZF_EXCLUDES"
export FZF_TMUX=1

# Override functions in fzf/completion.zsh
# TODO -- consider overriding their settings too
_fzf_compgen_path() {
  echo "$1"
  command bfs -L "$1" -color \
    -name .git -prune -o -name .svn -prune -o \( -type d -o -type f -o -type l \) \
    -a -not -path "$1" -print 2> /dev/null | sed -E 's@^([^/]*)\./@\1@'
}
_fzf_compgen_dir() {
  command bfs -L "$1" -color \
    -name .git -prune -o -name .svn -prune -o -type d \
    -a -not -path "$1" -print 2> /dev/null | sed -E 's@^([^/]*)\./@\1@'
}
#}}}
if [[ -a ~/.zsh/fzf/completion.zsh ]]; then
  source ~/.zsh/fzf/key-bindings.zsh
fi
if [[ -a ~/.zsh/fzf/key-bindings.zsh ]]; then
  source ~/.zsh/fzf/completion.zsh
fi

#{{{ Editor/CD Widgets
fzf-editor() {
  local file="$(__fsel)"
  # local file=$(echo -e "$fzfout" | sed 's/^[ \t]*//;s/[ \t]*$//')
  # Open the file if it exists
  if [ -n "$file" ]; then
    # Use the default editor if it's defined, otherwise Vim
    # Overwrite the contents of the buffer, do not append
    LBUFFER="${EDITOR:-vim} ${file}"
    # Accept line so it shows up in history as a regular command and is attached to the TTY without redirection
    zle accept-line
  else;
    zle reset-prompt
  fi
  local ret=$?
  return $ret
}
zle -N fzf-editor

fzf-editor-dir() {
  local oldt="$FZF_CTRL_T_COMMAND"
  FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND \"$1\""; fzf-editor
  export FZF_CTRL_T_COMMAND="$oldt"

  # Would be nice to get working
  # Replace $HOME with a tilde, but would require changes in __fsel
  # local homediresc=$(echo "$HOME" | sed 's/[]\/$*.^[]/\\&/g')
  # echo $homediresc
  # FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND ~ | sed 's/$homediresc/~/g'"; fzf_then_open_in_editor
}

fzf-cd-dir() {
  local oldc="$FZF_ALT_C_COMMAND"
  FZF_ALT_C_COMMAND="$FZF_ALT_C_COMMAND \"$1\""; fzf-cd-widget
  export FZF_ALT_C_COMMAND="$oldc"
}

fzf-ctrlt-dir() {
  local oldt="$FZF_CTRL_T_COMMAND"
  FZF_CTRL_T_COMMAND="$FZF_BOTH_COMMAND \"$1\""; fzf-file-widget
  export FZF_CTRL_T_COMMAND="$oldt"
}

fzf-editor-home() {
  fzf-editor-dir $HOME
}
zle -N fzf-editor-home

fzf-editor-source() {
  fzf-editor-dir $SOURCE_DIR
}
zle -N fzf-editor-source

fzf-editor-nas() {
  fzf-editor-dir $NASHOME
}
zle -N fzf-editor-nas

fzf-cd-home() {
  fzf-cd-dir $HOME
}
zle -N fzf-cd-home

fzf-cd-source() {
  fzf-cd-dir $SOURCE_DIR
}
zle -N fzf-cd-source

fzf-cd-nas() {
  fzf-cd-dir $NASHOME
}
zle -N fzf-cd-nas

fzf-ctrlt-current() {
  fzf-ctrlt-dir .
}
zle -N fzf-ctrlt-current

fzf-ctrlt-home() {
  fzf-ctrlt-dir $HOME
}
zle -N fzf-ctrlt-home

fzf-ctrlt-source() {
  fzf-ctrlt-dir $SOURCE_DIR
}
zle -N fzf-ctrlt-source

fzf-ctrlt-nas() {
  fzf-ctrlt-dir $NASHOME
}
zle -N fzf-ctrlt-nas
#}}}

# TODO -- The P bindings would be nice if they were "project" level
bindkey '^P' fzf-editor
bindkey '^Q' fzf-editor-home
bindkey '^S' fzf-editor-source
bindkey '^D' fzf-editor-nas
bindkey '^[p' fzf-cd-widget
bindkey '^[q' fzf-cd-home
bindkey '^[s' fzf-cd-source
bindkey '^[d' fzf-cd-nas
bindkey '^[^P' fzf-ctrlt-current
bindkey '^[^Q' fzf-ctrlt-home
bindkey '^[^S' fzf-ctrlt-source
bindkey '^[^D' fzf-ctrlt-nas

# fkill - kill process
# https://github.com/junegunn/fzf/wiki/examples#processes
fkill() {
  local pid
  pid=$(ps ax -O user | sed 1d | fzf-tmux -m | awk '{print $1}')

  if [[ -n "${pid// }" ]]; then
    echo $pid | xargs kill -${1:-15}
  fi
}
#}}}
#{{{ Completion
# Can potentially cause slowdown, disable to require explicit rehashes
zstyle ':completion:*' rehash true

# Use caching so that commands like apt and dpkg complete are useable
#zstyle ':completion::complete:*' use-cache on
#zstyle ':completion:*' cache-path ~/.zsh/cache
#zstyle ':completion:*' accept-exact '*(N)'

setopt always_to_end
setopt completealiases
setopt hash_list_all

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'


# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' original false
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
__git_files () {
    _wanted files expl 'local files' _files
}
#}}}
#{{{ Plugins
if [[ ! -d ~/.zplug ]];then
  git clone --depth 1 https://github.com/b4b4r07/zplug ~/.zplug
fi
# Source plugins as late as possible
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/46
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-completions"
zplug "plugins/taskwarrior", from:oh-my-zsh
# ctrl-z twice to fg application
zplug "plugins/fancy-ctrl-z", from:oh-my-zsh
# = 1+1, must be deferred after zsh-syntax-highlighting
zplug "arzzen/calc.plugin.zsh", defer:3
# Loading this plugin multiple times causes zsh to slow down
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug load

ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
#}}}

# Record mtime for auto-sourcing on change
__zshrc_sourced=$(stat-rc)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Enforce unique PATH, unsets $PATH for the rest of the script
typeset -U path

