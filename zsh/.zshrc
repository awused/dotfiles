# Created by desuwa for 5.2
# ~/.zshrc
# Install fzf, ripgrep, and bfs
# Uses BFS for fzf, but ripgrep for fzf in vim

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return


##### Zplug
# zplug install, zplug update, zplug clean
if [[ ! -d ~/.zplug ]];then
  git clone --depth 1 https://github.com/b4b4r07/zplug ~/.zplug
fi

##### Auto-source
stat-rc() {
 echo -n $(stat -f %m $(readlink -f ~/.zshrc))
}
zle -N stat-rc

zshrc_sourced=$(stat-rc)
precmd() {
  if (( $zshrc_sourced != $(stat-rc) )) {
    zshrc_sourced=$(stat-rc)
    source ~/.zshrc
  }
}

stty icrnl
umask 002

alias j='jobs -l'
alias ls='ls -G'
alias la='ls -aF'
alias lf='ls -F'
alias ll='ls -laFh'
alias lv='exa -lFiHhag --time-style=long-iso'
alias tree='exa -Ta -L'
alias treel='exa -Tal --time-style=long-iso -L'
alias clang-format='clang-format50'
eval $(thefuck --alias)

alias mux='tmuxinator'
alias tm='tmux attach -d -t main'

export EDITOR='vim'
export PAGER='less'
export LANG=en_US.UTF-8
# https://geoff.greer.fm/lscolors/
export LSCOLORS=ExGxdxdxCxDxDxBxBxegeg
export LS_COLORS="di=1;34:ln=1;36:so=33:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=34;46:ow=34;46"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

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

# Say how long a command took, if it took more than 30 seconds
export REPORTTIME=30

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Set TIME_STYLE for GNU coreutils
export TIME_STYLE="long-iso"


# Typing errors...
alias 'cd..=cd ..'

# Fix HOME/END
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

autoload -U history-search-end
zle -N history-beginning-search-forward-end history-search-end
zle -N history-beginning-search-backward-end history-search-end

# History searching
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

# Fix weird broken keybinds
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
alias mmv='noglob zmv -W'


# Quote URLs automatically
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -U url-quote-magic
zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='
zle -N self-insert url-quote-magic


##### FreeBSD specific settings
if [[ $(uname) == 'FreeBSD' ]]; then
  # Set equivalent date formats for BSD
  alias date='date +"%Y-%m-%d %H:%M:%S"'
  alias ls='ls -G -D "%Y-%m-%d %H:%M:%S"'
  alias cutleaves='pkg_cutleaves -Rxg'

  # cdp to jump to ports dir
  cdp() {
   cd $(whereis -qs $1)
  }
  zle -N cdp
fi


##### Load passwords from unsecured password-store
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

# TODO -- could pull this from nginx config files
add-subdomain() {
  [[ $#@ -eq 1 ]] || echo "Must supply exactly one new subdomain"
  __print-subdomains $1 | pass insert -fm subdomains >/dev/null 2>&1
  return $?
}
zle -N add-subdomain

alias weechat='export WEECHAT_PASSPHRASE=$(get-automation-password weechat); unalias weechat; weechat'

##### shrink-path
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

##### FZF
# CTRL-T - paste into cli
# ALT-C - CD into directory
# ALT-H - CD into directory starting from home
# CTRL-R - search history
# CTRL-P - open in vim
# CTRL-H - open from home directory in vim
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --ansi -m'
#export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --color "always" -g "!**/{.git,node_modules,vendor,.sass-cache}/*" 2> /dev/null'
#export FZF_DEFAULT_COMMAND='fd --no-ignore --type file --hidden --follow --color "always" --exclude "**/{.git,node_modules,vendor,.sass-cache}"'
export FZF_DEFAULT_COMMAND="bfs -L -color \
  -not \( -path '*/.git/*' -prune \) \
  -not \( -path '*/node_modules' -prune \) \
  -not \( -path '*/vendor' -prune \) \
  -not \( -path '*/.sass-cache' -prune \) \
  -not \( -path '*/.vim/*' -prune \) \
  -type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="bfs -L -type d -nohidden -color"
export FZF_TMUX=1
if [[ -a ~/.zsh/fzf/completion.zsh ]]; then
  source ~/.zsh/fzf/key-bindings.zsh
fi
if [[ -a ~/.zsh/fzf/key-bindings.zsh ]]; then
  source ~/.zsh/fzf/completion.zsh
fi

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

fzf-editor-home() {
  local oldt="$FZF_CTRL_T_COMMAND"
  FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND ~"; fzf-editor
  export FZF_CTRL_T_COMMAND="$oldt"

  # Would be nice to get working
  # Replace $HOME with a tilde, but would require changes in __fsel
  # local homediresc=$(echo "$HOME" | sed 's/[]\/$*.^[]/\\&/g')
  # echo $homediresc
  # FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND ~ | sed 's/$homediresc/~/g'"; fzf_then_open_in_editor
}
zle -N fzf-editor-home

fzf-cd-home() {
  local oldc="$FZF_ALT_C_COMMAND"
  FZF_ALT_C_COMMAND="$FZF_ALT_C_COMMAND ~"; fzf-cd-widget
  export FZF_ALT_C_COMMAND="$oldc"
}
zle -N fzf-cd-home

bindkey -r '^P'
bindkey '^P' fzf-editor
bindkey -r '^H'
bindkey '^H' fzf-editor-home
bindkey -r '^[h'
bindkey '^[h' fzf-cd-home


##### Completion
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
zstyle :compinstall filename '/usr/home/desuwa/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Source plugins as late as possible
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/46
source ~/.zplug/init.zsh
# = 1+1
zplug "arzzen/calc.plugin.zsh"
# Loading this plugin multiple times causes vim to slow down
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug load

ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold

# Enforce unique PATH, unsets $PATH for the rest of the script
typeset -U path

