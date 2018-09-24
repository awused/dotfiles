default:
	@grep '^[^#[:space:]].*:' Makefile

# Get permissions early so it's not prompting during multi-threaded builds
sudo:
	sudo echo "Starting"

wallpapers:
	go install github.com/awused/wallpapers

dispatcher:
	go install github.com/awused/dispatcher

add-to-transmission:
	go install github.com/awused/add-to-transmission

upscale-directory:
	go install github.com/awused/upscale-directory

public-clipboard:
	go install github.com/awused/public-clipboard

screenshotter:
	go install github.com/awused/screenshotter

madokami:
	go install github.com/awused/madokami

hydrus-mover:
	go install github.com/awused/hydrus-mover

go: wallpapers dispatcher add-to-transmission \
  upscale-directory public-clipboard screenshotter madokami \
  hydrus-mover


# Third party code
bfs: sudo
	cd ${THIRD_PARTY_SOURCE}/bfs; $(MAKE) clean; \
	  $(MAKE); sudo $(MAKE) install

i3-gaps: sudo
	cd ${THIRD_PARTY_SOURCE}/i3-gaps; \
	  autoreconf --force --install; \
	  rm -rf build/; mkdir build; cd build; \
	  ../configure; $(MAKE); sudo $(MAKE) install

loudness-scanner: sudo
	cd ${THIRD_PARTY_SOURCE}/loudness-scanner; \
	  mkdir -p fedora; cd fedora; cmake ..; \
	  $(MAKE); sudo $(MAKE) install

rofi: sudo
	cd ${THIRD_PARTY_SOURCE}/rofi; \
	  git submodule update; \
	  autoreconf --force --install; \
	  rm -rf build; mkdir -p build; cd build; \
	  ../configure; $(MAKE); sudo $(MAKE) install

split2flac: sudo
	sudo mkdir -p /usr/local/bin ; \
	  sudo install -m755 ${THIRD_PARTY_SOURCE}/split2flac/split2flac \
	  /usr/local/bin/split2flac

timg: sudo
	cd ${THIRD_PARTY_SOURCE}/timg/src; $(MAKE) clean; \
	  git checkout master; $(MAKE); sudo $(MAKE) install

waifu2x: sudo
	cd ${THIRD_PARTY_SOURCE}/waifu2x-converter-cpp; \
	  mkdir -p fedora; cd fedora; cmake ..; \
	  $(MAKE); sudo $(MAKE) install


third-party: bfs i3-gaps loudness-scanner rofi split2flac timg waifu2x

all-install: go third-party

gems: sudo
	gem update
	sudo gem update

pip: sudo
	sudo python3 -m pip install pip --upgrade
	python3 -m pip install \
	 $$(python3 -m pip list --format=columns --outdated \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4') \
	   --upgrade --user
	sudo pip2 install pip --upgrade
	pip2 install \
	 $$(pip2 list --format=columns --outdated \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4') \
	   --upgrade --user
npm: sudo
	sudo npm update -g

opam:
	opam update
	opam upgrade

flatpak:
	flatpak update --user

#go-update:
#	go get -u all

update: gems pip npm opam flatpak

