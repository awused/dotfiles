default:
	@grep '^[^#[:space:]].*:' Makefile

# Get permissions early so it's not prompting during multi-threaded builds
sudo:
	sudo echo "Starting"


# Go

add-to-transmission:
	cd ${AWUSED_SOURCE}/add-to-transmission; go install

# aw-man:
# 	cd ${AWUSED_SOURCE}/aw-man; go install

dispatcher:
	cd ${AWUSED_SOURCE}/dispatcher; go install

hydrus-mover:
	cd ${AWUSED_SOURCE}/hydrus-mover; go install

madokami:
	cd ${AWUSED_SOURCE}/madokami; go install

manga-syncer:
	cd ${AWUSED_SOURCE}/manga-syncer; go install

manga-upscaler:
	cd ${AWUSED_SOURCE}/manga-upscaler; go install

mpd-fzf:
	cd ${AWUSED_SOURCE}/mpd-fzf; go install

mpd-rofi:
	cd ${AWUSED_SOURCE}/mpd-rofi; go install

mpd-shuffler:
	cd ${AWUSED_SOURCE}/mpd-shuffler; go install

public-clipboard:
	cd ${AWUSED_SOURCE}/public-clipboard; go install

rss-scrapers:
	cd ${AWUSED_SOURCE}/rss-scrapers; go install ./...

screenshotter:
	cd ${AWUSED_SOURCE}/screenshotter; go install

strpick:
	cd ${AWUSED_SOURCE}/go-strpick/strpick; go install

upscale-directory:
	cd ${AWUSED_SOURCE}/upscale-directory; go install

vmrpc:
	cd ${AWUSED_SOURCE}/vmrpc/clipboard; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${AWUSED_SOURCE}/vmrpc/mpd; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${AWUSED_SOURCE}/vmrpc/monitors; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${AWUSED_SOURCE}/vmrpc/scream; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${AWUSED_SOURCE}/vmrpc/sharex; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${AWUSED_SOURCE}/vmrpc/usb; \
	  protoc --go_out=plugins=grpc:. *.proto
	cd ${AWUSED_SOURCE}/vmrpc/vmrpc-server; go install
	cd ${AWUSED_SOURCE}/vmrpc/vmrpc-client; go install

wallpapers:
	cd ${AWUSED_SOURCE}/wallpapers; go install


go: wallpapers dispatcher add-to-transmission \
  upscale-directory public-clipboard screenshotter madokami \
  hydrus-mover mpd-fzf mpd-rofi mpd-shuffler vmrpc rss-scrapers \
  strpick manga-upscaler manga-syncer

windows-clipboard:
	cd ${AWUSED_SOURCE}/public-clipboard; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/

windows-quiet-cmd:
	cd ${AWUSED_SOURCE}/quiet-cmd; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/

windows-sharex: vmrpc
	cd ${AWUSED_SOURCE}/sharex-mover; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/

windows-vmrpc: vmrpc
	cd ${AWUSED_SOURCE}/vmrpc/vmrpc-client; \
	  GOOS=windows go build -ldflags -H=windowsgui; \
	  mv *.exe /storage/winshare/gobin/; \
	cd ${AWUSED_SOURCE}/vmrpc/vmrpc-client; \
	  GOOS=windows go build; \
	  mv vmrpc-client.exe /storage/winshare/gobin/vmrpc-client-debug.exe

windows-wallpapers:
	cd ${AWUSED_SOURCE}/wallpapers; \
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

# i3-gaps: sudo
# 	cd ${THIRD_PARTY_SOURCE}/i3-gaps; \
# 	  rm -rf build/; mkdir build; cd build; \
# 	  meson ..; ninja; \
# 	  sudo meson install

loudness-scanner: sudo
	cd ${THIRD_PARTY_SOURCE}/loudness-scanner; \
	  rm -rf fedora/; mkdir -p fedora; cd fedora; \
	  cmake .. -DDISABLE_SNDFILE=True; $(MAKE); sudo $(MAKE) install

maim: sudo slop
	cd ${THIRD_PARTY_SOURCE}/maim; \
	  rm -rf build/; mkdir build; cd build; \
	  cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..; $(MAKE); sudo $(MAKE) install

# neovim: sudo
# 	cd "${THIRD_PARTY_SOURCE}/neovim"; \
# 	$(MAKE) clean; sudo $(MAKE) CMAKE_BUILD_TYPE=Release install
#
# mpv: sudo
# 	cd ${THIRD_PARTY_SOURCE}/mpv; \
# 	  ./waf clean; \
# 	  ./waf configure; ./waf; sudo ./waf install

rofi-files:
	cd ${THIRD_PARTY_SOURCE}/rofi-file-browser-extended; \
		rm -rf build/; mkdir build; cd build; \
		mkdir -p ~/.local/lib/rofi-plugins; \
		cmake ..; $(MAKE); mv filebrowser.so ~/.local/lib/rofi-plugins/filebrowser-extended.so

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
	  mv waifu2x-ncnn-vulkan ~/.bin/; \
	  ln -s "${THIRD_PARTY_SOURCE}/waifu2x-ncnn-vulkan/models/models-cunet" ~/.bin/

third-party: bfs ddcutil loudness-scanner maim rofi-files scream split2flac timg \
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

rust:
	rustup update

cargo:
	cargo install cargo-criterion cargo-udeps rusty-man

aw-man:
	cargo install --path "${AWUSED_SOURCE}/aw-man"

#go-update:
#	go get -u all


# TODO -- Cargo updates once alactritty is available from cargo

# update: gems pip npm opam flatpak

vim-plug:
	nvim +PlugUpgrade +PlugUpdate +qall

zplug:
	zsh -c 'export PS1="a"; source ~/.zshrc; zplug update'

plugins: vim-plug zplug
