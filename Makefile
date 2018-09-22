default:
	@echo specify desktop or server

PACKAGES = $(wildcard */)


unstow:
	stow -D ${PACKAGES}

both:
	stow bin
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
	stow nemo
	stow pulse
	stow xdg
	stow slack
	crontab desktop.user.crontab
	sudo crontab desktop.root.crontab

	stow xorg
	sudo cp xorg.conf.d/* /etc/X11/xorg.conf.d/


server: both
	stow server
	stow mpd
	stow weechat
	crontab server.user.crontab
	sudo crontab server.root.crontab
