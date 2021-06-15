default:
	@grep '^[^#[:space:]].*:' Makefile

# Get permissions early so it's not prompting during multi-threaded builds
sudo:
	sudo echo "Starting"


# Go

add-to-transmission:
	cd ${SOURCE_DIR}/add-to-transmission; go install

dispatcher:
	cd ${SOURCE_DIR}/dispatcher; go install

hydrus-mover:
	cd ${SOURCE_DIR}/hydrus-mover; go install

madokami:
	cd ${SOURCE_DIR}/madokami; go install

manga-syncer:
	cd ${SOURCE_DIR}/manga-syncer; go install

manga-upscaler:
	cd ${SOURCE_DIR}/manga-upscaler; go install

mpd-fzf:
	cd ${SOURCE_DIR}/mpd-fzf; go install

mpd-rofi:
	cd ${SOURCE_DIR}/mpd-rofi; go install

mpd-shuffler:
	cd ${SOURCE_DIR}/mpd-shuffler; go install

public-clipboard:
	cd ${SOURCE_DIR}/public-clipboard; go install

rss-scrapers:
	cd ${SOURCE_DIR}/rss-scrapers; go install ./...

screenshotter:
	cd ${SOURCE_DIR}/screenshotter; go install

strpick:
	cd ${SOURCE_DIR}/go-strpick/strpick; go install

upscale-directory:
	cd ${SOURCE_DIR}/upscale-directory; go install

vmrpc:
	cd ${SOURCE_DIR}/vmrpc/clipboard; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${SOURCE_DIR}/vmrpc/mpd; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${SOURCE_DIR}/vmrpc/monitors; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${SOURCE_DIR}/vmrpc/scream; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${SOURCE_DIR}/vmrpc/sharex; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${SOURCE_DIR}/vmrpc/usb; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${SOURCE_DIR}/vmrpc/vmrpc-server; go install
	cd ${SOURCE_DIR}/vmrpc/vmrpc-client; go install

wallpapers:
	cd ${SOURCE_DIR}/wallpapers; go install


go: wallpapers dispatcher add-to-transmission \
  upscale-directory public-clipboard screenshotter madokami \
  hydrus-mover mpd-fzf mpd-rofi mpd-shuffler vmrpc rss-scrapers \
  strpick manga-upscaler manga-syncer

windows-clipboard:
	cd ${SOURCE_DIR}/public-clipboard; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/

windows-quiet-cmd:
	cd ${SOURCE_DIR}/quiet-cmd; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/

windows-sharex: vmrpc
	cd ${SOURCE_DIR}/sharex-mover; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/

windows-vmrpc: vmrpc
	cd ${SOURCE_DIR}/vmrpc/vmrpc-client; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/; \
	cd ${SOURCE_DIR}/vmrpc/vmrpc-client; \
	  GOOS=windows go build; \
	  mv vmrpc-client.exe /storage/winshare/gobin/vmrpc-client-debug.exe

windows-wallpapers:
	cd ${SOURCE_DIR}/wallpapers; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  GOOS=windows go build -o wallcon.exe; \
	  mv wallpapers.exe wallcon.exe /storage/winshare/gobin/

windows-go: windows-wallpapers windows-sharex windows-vmrpc windows-clipboard windows-quiet-cmd

# Third party code
bfs: sudo
	cd ${THIRD_PARTY_SOURCE}/bfs; $(MAKE) clean; \
	  $(MAKE); sudo $(MAKE) install

ddcutil: sudo
	cd ${THIRD_PARTY_SOURCE}/ddcutil; ./autogen.sh; \
	  $(MAKE); sudo $(MAKE) install

i3-gaps: sudo
	cd ${THIRD_PARTY_SOURCE}/i3-gaps; \
	  rm -rf build/; mkdir build; cd build; \
	  meson ..; ninja; \
	  sudo meson install

maim: sudo slop
	cd ${THIRD_PARTY_SOURCE}/maim; \
	  rm -rf build/; mkdir build; cd build; \
	  cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..; $(MAKE); sudo $(MAKE) install

loudness-scanner: sudo
	cd ${THIRD_PARTY_SOURCE}/loudness-scanner; \
	  rm -rf fedora/; mkdir -p fedora; cd fedora; \
	  cmake .. -DDISABLE_SNDFILE=True; $(MAKE); sudo $(MAKE) install

# mpv: sudo
# 	cd ${THIRD_PARTY_SOURCE}/mpv; \
# 	  ./waf clean; \
# 	  ./waf configure; ./waf; sudo ./waf install

scream:
	cd ${THIRD_PARTY_SOURCE}/scream/Receivers/unix; \
	  rm -rf build/; mkdir build; cd build; \
	  cmake ..; $(MAKE); mv scream ~/.bin/

slop: sudo
	cd ${THIRD_PARTY_SOURCE}/slop; \
	  rm -rf build/; mkdir build; cd build; \
	  cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..; $(MAKE); sudo $(MAKE) install

split2flac: sudo
	sudo mkdir -p /usr/local/bin ; \
	  sudo install -m755 ${THIRD_PARTY_SOURCE}/split2flac/split2flac \
	  /usr/local/bin/split2flac

timg: sudo
	cd ${THIRD_PARTY_SOURCE}/timg/src; $(MAKE) clean; \
	  git checkout master; $(MAKE); sudo $(MAKE) install

# waifu2x: sudo
# 	cd ${THIRD_PARTY_SOURCE}/waifu2x-converter-cpp; \
# 	  rm -rf fedora/; mkdir -p fedora; cd fedora; CC=cuda-gcc CPP=cuda-++ CXX=cuda-g++ LD=cuda-g++ cmake ..; \
# 	  rg-replace '/usr/bin/nvcc -arch=sm_30' -r '/usr/bin/nvcc --compiler-bindir /usr/bin/cuda-gcc -arch=sm_30' **/* \
# 	  $(MAKE); sudo $(MAKE) install

# ncnn:
# 	rm -rf "${THIRD_PARTY_SOURCE}/temp/ncnn"; cd ${THIRD_PARTY_SOURCE}/ncnn; \
# 	  rm -rf build/; mkdir build; cd build; \
# 	  cmake -DNCNN_VULKAN=ON \
# 	        -DCMAKE_INSTALL_PREFIX="${THIRD_PARTY_SOURCE}/temp/ncnn" \
# 		-DCMAKE_BUILD_TYPE=Release ..; \
# 	  $(MAKE) install;

waifu2x-vulkan:
	  cd "${THIRD_PARTY_SOURCE}/waifu2x-ncnn-vulkan"; \
	  rm -rf build/; mkdir build; cd build; \
	  cmake ../src; $(MAKE); \
	  mv waifu2x-ncnn-vulkan ~/.bin/


third-party: bfs ddcutil i3-gaps loudness-scanner maim scream split2flac timg \
	waifu2x-vulkan
  # waifu2x mpv

all-install: go third-party

gems: sudo
	gem update
	#sudo gem update

pip:
	python3 -m pip install \
	 $$(pip3 list --format=columns --outdated --user \
	   | sed 1,2d | tr '\n' ' ' | sed -r 's/ +/ /g' \
	   | awk -v RS=" " '1==NR%4') \
	   --upgrade --user || true
npm:
	npm update -g

opam:
	opam update
	source ~/.zshenv; opam upgrade

flatpak:
	flatpak update --user
	flatpak uninstall --unused

#go-update:
#	go get -u all


# TODO -- Cargo updates once alactritty is available from cargo

# update: gems pip npm opam flatpak

vim-plug:
	vim +PlugUpgrade +PlugUpdate +qall

zplug:
	zsh -c 'export PS1="a"; source ~/.zshrc; zplug update'

plugins: vim-plug zplug
