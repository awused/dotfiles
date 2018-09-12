default:
	@echo specify desktop or server

PACKAGES = $(wildcard */)


unstow:
	stow -D ${PACKAGES}

both:
	stow bin
	stow config
	stow cron
	stow gnupg
	stow misc
	stow password-store
	stow restic
	stow task
	stow tmux
	stow vim
	stow zsh

desktop: both
	stow desktop

server: both
	stow server
	stow mpd
	stow weechat
