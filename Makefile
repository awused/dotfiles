default:
	@echo specify desktop or server

.NOTPARALLEL:

PACKAGES = $(wildcard */)


unstow:
	stow -D ${PACKAGES}

both:
	# mkdir -p ~/.duplicacy-repo/.duplicacy
	stow bin
	stow cron
	# stow duplicacy
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
	git config --global core.hooksPath ~/.config/git-hooks
	git config --global core.filemode true
	git config --global pull.ff only
	git config --global credential.helper store
	git config --global credential.'https://source.developers.google.com'.helper gcloud.sh

sudo:
	sudo echo "Starting"

desktop: sudo both
	stow desktop
	stow gui
	stow mcomix
	stow mpd
	stow mpv
	stow pulse
	# stow xdg -- constantly overwritten
	crontab desktop.user.crontab
	sudo crontab desktop.root.crontab
	stow xorg
	# sudo cp -u xorg.conf.d/* /etc/X11/xorg.conf.d/
	# sudo cp -u lightdm/lightdm.conf /etc/lightdm/
	# sudo cp -u lightdm/display-setup.sh /etc/lightdm/
	# TODO -- recursive mkdir -p
	sudo cp -uv --no-preserve=ownership root-scripts/desktop/* /root/
	sudo cp -uvr --no-preserve=ownership etc/desktop/* /etc/
	#ln -s /home/ ~/.duplicacy-repo/ || true


server: both
	stow server
	stow weechat
	crontab server.user.crontab
	sudo crontab server.root.crontab
	sudo cp -uv --no-preserve=ownership root-scripts/server/* /root/
	sudo cp -uvr --no-preserve=ownership etc/server/* /etc/
