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
	stow ocaml
	stow password-store
	stow restic
	stow task
	stow tmux
	stow vim
	stow youtube-dl
	stow zsh

desktop: both
	stow desktop
	stow gui
	stow mcomix
	stow mpv
	stow pulse
	stow thunar
	stow xdg
	crontab desktop.user.crontab
	sudo crontab desktop.root.crontab

server: both
	stow server
	stow mpd
	stow weechat
	crontab server.user.crontab
	sudo crontab server.root.crontab
