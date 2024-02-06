#!/bin/bash
# Hyprland Packages #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# AUR
ISAUR=$(command -v yay || command -v paru)

# Function for installing packages
install_package() {
	if $ISAUR -Q "$1" &>>/dev/null; then
		echo -e "${OK} $1 is already installed. Skipping..."
	else
		echo -e "${NOTE} Installing $1 ..."
		$ISAUR -S --noconfirm "$1"
		if $ISAUR -Q "$1" &>>/dev/null; then
			echo -e "\e[1A\e[K${OK} $1 was installed."
		else
			echo -e "\e[1A\e[K${ERROR} $1 failed to install. You may need to install manually! Sorry I have tried :("
		fi
	fi
}

uninstall_package() {
	if pacman -Qi "$1" &>>/dev/null; then
		echo -e "${NOTE} Uninstalling $1 ..."
		sudo pacman -Rns --noconfirm "$1"
		if ! pacman -Qi "$1" &>>/dev/null; then
			echo -e "\e[1A\e[K${OK} $1 was uninstalled."
		else
			echo -e "\e[1A\e[K${ERROR} $1 failed to uninstall"
		fi
	fi
}

# add packages wanted here
extra=(
	microsoft-edge-stable
	arttime-git
	shell-color-scripts
	pipes.sh
)

hypr_package=(
	cliphist
	curl
	grim
	gvfs
	gvfs-mtp
	imagemagick
	jq
	kitty
	kvantum
	nano
	network-manager-applet
	pamixer
	pavucontrol
	pipewire-alsa
	playerctl
	polkit-gnome
	python-requests
	python-pywal
	qt5ct
	qt6ct
	qt6-svg
	rofi-lbonn-wayland-git
	slurp
	swappy
	swayidle
	swaylock-effects-git
	swaync
	swww
	waybar
	wget
	wl-clipboard
	wlogout
	xdg-user-dirs
	xdg-utils
	yad
)

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_optional=(
	brightnessctl
	btop
	cava
	eog
	gnome-system-monitor
	mousepad
	mpv
	mpv-mpris
	nvtop
	nwg-look-bin
	pacman-contrib
	vim
	yt-dlp
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

for PKG1 in "${hypr_package[@]}" "${hypr_package_optional[@]}" "${fonts[@]}" "${extra[@]}"; do
	install_package "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done

# Checking if mako or dunst is installed
printf "\n%s - Checking if mako or dunst are installed and removing for swaync to work properly \n" "${NOTE}"
for PKG in "${uninstall[@]}"; do
	uninstall_package "$PKG"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG uninstallation had failed"
	fi
done
