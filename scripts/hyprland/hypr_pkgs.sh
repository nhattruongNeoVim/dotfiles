#!/bin/bash
# Hyprland Packages

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# start script
hypr_aur_package=(
	gvfs
	gvfs-mtp
	imagemagick
	kitty
	kvantum
	nano
	python-requests
	qt6-svg
	rofi-lbonn-wayland-git
	swaylock-effects-git
	swaync
	swww
	wlogout
	cava
	eog
	mousepad
	mpv
	mpv-mpris
	nwg-look-bin
	pacman-contrib
	vim
	microsoft-edge-stable
	arttime-git
	shell-color-scripts
	pipes.sh
)

hypr_pacman_package=(
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

fonts=(
	adobe-source-code-pro-fonts
	noto-fonts-emoji
	otf-font-awesome
	ttf-droid
	ttf-fira-code
	ttf-jetbrains-mono
	ttf-jetbrains-mono-nerd
)

# List of packages to uninstall as it conflicts with swaync or causing swaync to not function properly
uninstall=(
	dunst
	mako
)

# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_aur_package[@]}" "${fonts[@]}"; do
	install_aur_pkg "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done

for PKG2 in "${hypr_pacman_package[@]}"; do
	install_pacman_pkg "$PKG2"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done

# Checking if mako or dunst is installed
printf "\n%s - Checking if mako or dunst are installed and removing for swaync to work properly \n" "${NOTE}"
for PKG in "${uninstall[@]}"; do
	uninstall_pacman_pkg "$PKG"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG uninstallation had failed"
	fi
done
