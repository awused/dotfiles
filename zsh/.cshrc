# $FreeBSD: releng/10.1/share/skel/dot.cshrc 266029 2014-05-14 15:23:06Z bdrewery $
#
# .cshrc - csh resource script, read at beginning of execution by each shell
#
# see also csh(1), environ(7).
# more examples available at /usr/share/examples/csh/

# Keep TCSH as login shell, it's part of the base system
# Switch to ZSH if it's available and this is an interactive login shell
if ($?prompt && $?loginsh) then
  if ( -f /usr/local/bin/zsh ) then
    #echo -n "Type Y to run zsh: "
    #if ( "$<" == Y ) exec /usr/local/bin/zsh -l
    exec /usr/local/bin/zsh -l
  endif
endif


umask 002

alias h		history 25
alias j		jobs -l
alias ls        ls -G
alias la	ls -aF
alias lf	ls -FA
alias ll	ls -lAF
alias mux       tmuxinator

# These are normally set through /etc/login.conf.  You may override them here
# if wanted.
# set path = (/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin $HOME/bin)
# setenv	BLOCKSIZE	K
# A righteous umask
# umask 22

setenv	EDITOR	vim
setenv  VISUAL  vim
setenv	PAGER	more
setenv  LANG    en_US.UTF-8
setenv  LSCOLORS ExGxdxdxCxDxDxBxBxegeg
setenv  GOPATH /usr/home/desuwa/go
setenv  GCLOUD_PATH /usr/home/desuwa/src/google-cloud-sdk/bin
setenv  PATH $PATH\:$GOPATH/bin\:$GCLOUD_PATH

if ($?prompt) then
	# An interactive shell -- set some stuff up
	set prompt = "%N@%m:%~ %# "
	set promptchars = "%#"

	set filec
	set history = 1000
	set savehist = (1000 merge)
	set autolist = ambiguous
	# Use history to aid expansion
	set autoexpand
	set autorehash
        set globstar
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
	endif

endif
