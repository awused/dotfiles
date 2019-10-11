default:
	@grep '^[^#[:space:]].*:' Makefile

# Get permissions early so it's not prompting during multi-threaded builds
sudo:
	sudo echo "Starting"


# Go

add-to-transmission:
	go install github.com/awused/add-to-transmission

dispatcher:
	go install github.com/awused/dispatcher

hydrus-mover:
	go install github.com/awused/hydrus-mover

madokami:
	go install github.com/awused/madokami

manga-upscaler:
	go install github.com/awused/manga-upscaler

mpd-fzf:
	go install github.com/awused/mpd-fzf

mpd-rofi:
	go install github.com/awused/mpd-rofi

mpd-shuffler:
	go install github.com/awused/mpd-shuffler

public-clipboard:
	go install github.com/awused/public-clipboard

rss-scrapers:
	go install github.com/awused/rss-scrapers/amiami-rss
	go install github.com/awused/rss-scrapers/awkward-rss
	go install github.com/awused/rss-scrapers/fiction-rss
	go install github.com/awused/rss-scrapers/gelbooru-rss
	go install github.com/awused/rss-scrapers/mangaplus-rss
	go install github.com/awused/rss-scrapers/panda-rss
	go install github.com/awused/rss-scrapers/seasonal-anime-rss
	go install github.com/awused/rss-scrapers/tfgames-rss
	go install github.com/awused/rss-scrapers/vn-news-rss
	go install github.com/awused/rss-scrapers/webnovel-rss

screenshotter:
	go install github.com/awused/screenshotter

strpick:
	go install github.com/awused/go-strpick/strpick

upscale-directory:
	go install github.com/awused/upscale-directory

vmrpc:
	cd ${GOPATH}/src/github.com/awused/vmrpc/clipboard; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${GOPATH}/src/github.com/awused/vmrpc/mpd; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${GOPATH}/src/github.com/awused/vmrpc/scream; \
	  protoc --go_out=plugins=grpc:. *.proto
	go install github.com/awused/vmrpc/vmrpc-server
	go install github.com/awused/vmrpc/vmrpc-client

wallpapers:
	go install github.com/awused/wallpapers


go: wallpapers dispatcher add-to-transmission \
  upscale-directory public-clipboard screenshotter madokami \
  hydrus-mover mpd-fzf mpd-rofi mpd-shuffler vmrpc rss-scrapers \
  strpick manga-upscaler


windows-wallpapers:
	cd /storage/winshare/gobin; \
	  GOOS=windows go build -ldflags -H=windowsgui github.com/awused/wallpapers; \
	  GOOS=windows go build -o wallcon.exe github.com/awused/wallpapers

windows-sharex: vmrpc
	cd /storage/winshare/gobin; \
	  GOOS=windows go build -ldflags -H=windowsgui github.com/awused/sharex-mover

windows-vmrpc: vmrpc
	cd /storage/winshare/gobin; \
	  GOOS=windows go build -ldflags -H=windowsgui github.com/awused/vmrpc/vmrpc-client

windows-clipboard:
	cd /storage/winshare/gobin; \
	  GOOS=windows go build -ldflags -H=windowsgui github.com/awused/public-clipboard

windows-go: windows-wallpapers windows-sharex windows-vmrpc windows-clipboard

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
	  rm -rf fedora/; mkdir -p fedora; cd fedora; \
	  cmake ..; $(MAKE); sudo $(MAKE) install

mpv: sudo
	cd ${THIRD_PARTY_SOURCE}/mpv; \
	  ./waf configure; ./waf; sudo ./waf install

rofi: sudo
	cd ${THIRD_PARTY_SOURCE}/rofi; \
	  git submodule update; \
	  autoreconf --force --install; \
	  rm -rf build; mkdir -p build; cd build; \
	  ../configure; $(MAKE); sudo $(MAKE) install

scream:
	cd ${THIRD_PARTY_SOURCE}/scream/Receivers/pulseaudio-ivshmem; \
	  $(MAKE); mv scream-ivshmem-pulse ~/.bin/

split2flac: sudo
	sudo mkdir -p /usr/local/bin ; \
	  sudo install -m755 ${THIRD_PARTY_SOURCE}/split2flac/split2flac \
	  /usr/local/bin/split2flac

timg: sudo
	cd ${THIRD_PARTY_SOURCE}/timg/src; $(MAKE) clean; \
	  git checkout master; $(MAKE); sudo $(MAKE) install

waifu2x: sudo
	cd ${THIRD_PARTY_SOURCE}/waifu2x-converter-cpp; \
	  rm -rf fedora/; mkdir -p fedora; cd fedora; CC=cuda-gcc CPP=cuda-++ CXX=cuda-g++ LD=cuda-g++ cmake ..; \
	  rg-replace '/usr/bin/nvcc -arch=sm_30' -r '/usr/bin/nvcc --compiler-bindir /usr/bin/cuda-gcc -arch=sm_30' **/* \
	  $(MAKE); sudo $(MAKE) install

ncnn:
	rm -rf "${THIRD_PARTY_SOURCE}/temp/ncnn"; cd ${THIRD_PARTY_SOURCE}/ncnn; \
	  rm -rf build/; mkdir build; cd build; \
	  cmake -DNCNN_VULKAN=ON \
	        -DCMAKE_INSTALL_PREFIX="${THIRD_PARTY_SOURCE}/temp/ncnn" \
		-DCMAKE_BUILD_TYPE=Release ..; \
	  $(MAKE) install;

waifu2x-vulkan: ncnn
	  cd "${THIRD_PARTY_SOURCE}/waifu2x-ncnn-vulkan"; \
	  rm -rf build/; mkdir build; cd build; \
	  LDFLAGS="-L${THIRD_PARTY_SOURCE}/temp/ncnn/lib" cmake ..; \
	  CPLUS_INCLUDE_PATH="${THIRD_PARTY_SOURCE}/temp/ncnn/include" $(MAKE); \
	  mv waifu2x-ncnn-vulkan ~/.bin/


polybar:
	cd ${THIRD_PARTY_SOURCE}/polybar; \
	  rm -rf build/; mkdir -p build; cd build; cmake ..; \
	  $(MAKE); sudo $(MAKE) install



third-party: bfs i3-gaps loudness-scanner rofi split2flac timg waifu2x waifu2x-vulkan \
  polybar scream mpv

all-install: go third-party

gems: sudo
	gem update
	sudo gem update

pip: sudo
	sudo pip3 install pip --upgrade
	python3 -m pip install \
	 $$(pip3 list --format=columns --outdated \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4' | grep -v -E 'libvirt|wxPython|bodhi' ) \
	   --upgrade --user || true
	sudo pip2 install pip --upgrade
	pip2 install \
	 $$(pip2 list --format=columns --outdated \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4' | grep -v -E 'libvirt|wxPython|bodhi' ) \
	   --upgrade --user
npm:
	npm update -g

opam:
	opam update
	source ~/.zshenv; opam upgrade

flatpak:
	flatpak update --user

#go-update:
#	go get -u all


# TODO -- Cargo updates once alactritty is available from cargo

# update: gems pip npm opam flatpak

vim-plug:
	vim +PlugUpgrade +PlugUpdate +qall

zplug:
	zsh -c 'export PS1="a"; source ~/.zshrc; zplug update'

plugins: vim-plug zplug
