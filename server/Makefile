default:
	@grep '^[^#[:space:]].*:' Makefile

# Get permissions early so it's not prompting during multi-threaded builds
sudo:
	sudo echo "Starting"

hydrus-mover:
	cd ${GOPATH}/src/github.com/awused/hydrus-mover; go install

manga-syncer:
	cd ${GOPATH}/src/github.com/awused/manga-syncer; go install

rss-scrapers:
	cd ${GOPATH}/src/github.com/awused/rss-scrapers; go install ./...

rss:
	cd ${GOPATH}/src/github.com/awused/aw-rss; go install

steam-screenshots:
	cd ${GOPATH}/src/github.com/awused/steam-screenshots; go install

go: hydrus-mover manga-syncer rss rss-scrapers steam-screenshots

# loudness-scanner: sudo
# 	cd ${THIRD_PARTY_SOURCE}/loudness-scanner; \
# 	  rm -rf build/; mkdir -p build; cd build; \
# 	  cmake ..; $(MAKE); sudo $(MAKE) install

# split2flac: sudo
# 	sudo mkdir -p /usr/local/bin ; \
# 	  sudo install -m755 ${THIRD_PARTY_SOURCE}/split2flac/split2flac \
# 	  /usr/local/bin/split2flac

#timg: sudo
#	cd ${THIRD_PARTY_SOURCE}/timg/src; $(MAKE) clean; \
#	  git checkout im7; $(MAKE); sudo $(MAKE) install

znc-clientbuffer: sudo
	cd ${THIRD_PARTY_SOURCE}/znc-clientbuffer; \
	  rm -f "clientbuffer.so"; $(MAKE); sudo $(MAKE) install

third-party: znc-clientbuffer

all-install: go third-party

gems: sudo
	gem update
	sudo gem update

pip: sudo
	sudo pip3 install pip --upgrade
	python3 -m pip install \
	 $$(pip3 list --format=columns --outdated \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4' | grep -v 'libvirt' ) \
	   --upgrade --user || true
	sudo pip2 install pip --upgrade
	pip2 install \
	 $$(pip2 list --format=columns --outdated \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4' | grep -v -E 'libvirt|wxPython' ) \
	   --upgrade --user
npm:
	npm update -g

#go-update:
#	go get -u all


# TODO -- Cargo updates once alactritty is available from cargo

# update: gems pip npm opam flatpak

vim-plug:
	vim +PlugUpgrade +PlugUpdate +qall

zplug:
	zsh -c 'export PS1="a"; source ~/.zshrc; zplug update'

plugins: vim-plug zplug
