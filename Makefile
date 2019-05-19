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

sudo:
	sudo echo "Starting"

desktop: sudo both
	stow desktop
	stow gui
	stow mcomix
	stow mpd
	stow mpv
	stow nemo
	stow pulse
	stow xdg
	stow slack
	crontab desktop.user.crontab
	sudo crontab desktop.root.crontab
	stow xorg
	sudo cp -u xorg.conf.d/* /etc/X11/xorg.conf.d/
	sudo cp -u lightdm/lightdm.conf /etc/lightdm/


server: both
	stow server
	stow weechat
	crontab server.user.crontab
	sudo crontab server.root.crontab
