default:
	@grep '^[^#[:space:]].*:' Makefile

.NOTPARALLEL:

# Get permissions early so it's not prompting during multi-threaded builds
sudo:
	sudo echo "Starting"

hydrus-mover:
	cd ${AWUSED_SOURCE}/hydrus-mover; go install


steam-screenshots:
	cd ${AWUSED_SOURCE}/steam-screenshots; go install

go: hydrus-mover steam-screenshots

manga-syncer:
	cargo install --path "${AWUSED_SOURCE}/manga-syncer" --locked

rss:
	cargo install --path "${AWUSED_SOURCE}/aw-rss" --locked

rss-scrapers:
	ROCKSDB_LIB_DIR=/usr/local/lib cargo install --path "${AWUSED_SOURCE}/rss-scrapers" --locked
	# cargo install --path "${AWUSED_SOURCE}/rss-scrapers" --locked

rust: manga-syncer rss rss-scrapers

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
	sudo gem update
	gem update

pip: sudo
	# sudo pip3 install pip --upgrade
	python3 -m pip install \
	 $$(pip3 list --format=columns --outdated \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4' | grep -v 'libvirt' ) \
	   --upgrade --user || true
npm:
	npm update -g

cargo:

#go-update:
#	go get -u all


# TODO -- Cargo updates once alactritty is available from cargo

# update: gems pip npm opam flatpak

vim-plug:
	nvim +PlugUpgrade +PlugUpdate +qall

zplug:
	zsh -c 'export PS1="a"; source ~/.zshrc; zplug update'

plugins: vim-plug zplug
