#!/bin/bash
# base devel

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# start script
base=(
	base-devel
	git
	libxcrypt-compat
)

pacman_packages=(
	alacritty
	tmux
	starship
	zsh
	make
	python-pip
	nodejs
	npm
	# python-virtualenv
	ripgrep
	fzf
	neofetch
	lsd
	lazygit
	net-tools
	neovim
	bat
	libreoffice-fresh
	jdk-openjdk
	file-roller
	gnome-disk-utility
	discord
	neovide
	ranger
	aria2
	btop
	curl
	yt-dlp
	brightnessctl
	grim
	waybar
	gnome-system-monitor
	jq
	slurp
	swappy
	cliphist
	network-manager-applet
	pamixer
	pavucontrol
	pipewire-alsa
	playerctl
	polkit-gnome
	python-pywal
	qt5ct
	qt6ct
	swappy
	swayidle
	wget
	wl-clipboard
	xdg-user-dirs
	xdg-utils
	yad
	nvtop
)

# Installation of main components
printf "\n%s - Installing components\n" "${NOTE}"
for PKG1 in "${base[@]}" "${pacman_packages[@]}"; do
	install_pacman_pkg "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done
