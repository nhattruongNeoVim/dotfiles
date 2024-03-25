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
			echo "-> $1 failed to install. You may need to install manually! Sorry I have tried :(" >>~/install.log
		fi
	fi
}

install_package_pacman() {
	if pacman -Q "$1" &>/dev/null; then
		echo -e "${OK} $1 is already installed. Skipping..."
	else
		echo -e "${NOTE} Installing $1 ..."
		sudo pacman -S --noconfirm "$1"
		if pacman -Q "$1" &>/dev/null; then
			echo -e "${OK} $1 was installed."
		else
			echo -e "${ERROR} $1 failed to install. You may need to install manually."
			echo "-> $1 failed to install. You may need to install manually! Sorry I have tried :(" >>~/install.log
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
			echo "-> $1 failed to uninstall" >>~/install.log
		fi
	fi
}

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
    vmware-workstation
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
	install_package "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done

for PKG2 in "${hypr_pacman_package[@]}"; do
	install_package_pacman "$PKG2"
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
