#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# variables
wallpaper=$HOME/Pictures/wallpapers/anime-kanji.jpg
waybar_style="$HOME/.config/waybar/style/simple [pywal].css"

# check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
	echo "This script should not be executed as root! Exiting......."
	exit 1
fi

# author
clear
gum style \
	--foreground 213 --border-foreground 213 --border rounded \
	--align center --width 90 --margin "1 2" --padding "2 4" \
	"  ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____  " \
	" |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    | " \
	" |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __| " \
	" |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  | " \
	" |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ | " \
	" |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     | " \
	" |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_| " \
	"                                                                              " \
	" ------------------- Script developed by nhattruongNeoVim ------------------- " \
	"                                                                              " \
	"  -------------- Github: https://github.com/nhattruongNeoVim ---------------  " \
	"                                                                              "

# check dotfiles
cd "$HOME" || exit 1
if [ -d dotfiles ]; then
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles config directory\n" "${ERROR}"
		exit 1
	}
else
	printf "\n${NOTE} Clone dotfiles. " && git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
		exit 1
	}
fi

# uncommenting WLR_NO_HARDWARE_CURSORS if nvidia is detected
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
	# NVIDIA GPU detected, uncomment line 23 in ENVariables.conf
	sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' config/hypr/configs/env_variables.conf
	sed -i '/env = LIBVA_DRIVER_NAME,nvidia/s/^#//' config/hypr/configs/env_variables.conf
	sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^#//' config/hypr/configs/env_variables.conf
fi

# uncommenting WLR_RENDERER_ALLOW_SOFTWARE,1 if running in a VM is detected
if hostnamectl | grep -q 'Chassis: vm'; then
	echo "This script is running in a virtual machine."
	sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' config/hypr/configs/env_variables.conf
	sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' config/hypr/configs/env_variables.conf
	sed -i '/monitor = Virtual-1, 1920x1080@60,auto,1/s/^#//' config/hypr/configs/monitors.conf
fi

# Function to detect keyboard layout using localectl or setxkbmap
detect_layout() {
	if command -v localectl >/dev/null 2>&1; then
		layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
		if [ -n "$layout" ]; then
			echo "$layout"
		else
			echo "unknown"
		fi
	elif command -v setxkbmap >/dev/null 2>&1; then
		layout=$(setxkbmap -query | grep layout | awk '{print $2}')
		if [ -n "$layout" ]; then
			echo "$layout"
		else
			echo "unknown"
		fi
	else
		echo "unknown"
	fi
}

# Detect the current keyboard layout
layout=$(detect_layout)

printf "${NOTE} Detecting keyboard layout to prepare necessary changes in hyprland.conf before copying\n\n"

# Prompt the user to confirm whether the detected layout is correct
if gum confirm "$ORANGE Detected current keyboard layout is: $layout. Is this correct?"; then
	# If the detected layout is correct, update the 'kb_layout=' line in the file
	awk -v layout="$layout" '/kb_layout/ {$0 = "  kb_layout=" layout} 1' config/hypr/configs/settings.conf >temp.conf
	mv temp.conf config/hypr/configs/settings.conf
	echo "${NOTE} kb_layout $layout configured in settings.  "
else
	printf "\n%.0s" {1..2}
	echo "$(tput bold)$(tput setaf 3)ATTENTION!!!! VERY IMPORTANT!!!! $(tput sgr0)"
	echo "$(tput bold)$(tput setaf 7)Setting a wrong value here will result in Hyprland not starting $(tput sgr0)"
	echo "$(tput bold)$(tput setaf 7)If you are not sure, keep it in us layout. You can change later on! $(tput sgr0)"
	echo "$(tput bold)$(tput setaf 7)You can also set more than 2 layouts!$(tput sgr0)"
	echo "$(tput bold)$(tput setaf 7)ie: us,vn,kr,es $(tput sgr0)"
	printf "\n%.0s" {1..2}
	read -p "${CAT} - Please enter the correct keyboard layout: " new_layout
	# Update the 'kb_layout=' line with the correct layout in the file
	awk -v new_layout="$new_layout" '/kb_layout/ {$0 = "  kb_layout=" new_layout} 1' config/hypr/configs/settings.conf >temp.conf
	mv temp.conf config/hypr/configs/settings.conf
	echo "${NOTE} kb_layout $new_layout configured in settings."
fi

printf "\n"

# Action to do for better rofi appearance
echo "$ORANGE Select monitor resolution for better Rofi appearance:"
echo -e "\t $YELLOW 1. Equal to or less than 1080p (≤ 1080p)"
echo -e "\t $YELLOW 2. Equal to or higher than 1440p (≥ 1440p)"

if gum confirm "$CAT Enter the number of your choice: " --affirmative "≤ 1080p" --negative "≥ 1440p"; then
	resolution="≤ 1080p"
else
	resolution="≥ 1440p"
fi

# Use the selected resolution in your existing script
echo "\n\nYou chose $resolution resolution for better Rofi appearance.\n\n"

# Add your commands based on the resolution choice
if [ "$resolution" == "≤ 1080p" ]; then
	cp -r config/rofi/resolution/1080p/* config/rofi/
elif [ "$resolution" == "≥ 1440p" ]; then
	cp -r config/rofi/resolution/1440p/* config/rofi/
fi

### Copy Config Files ###
set -e # Exit immediately if a command exits with a non-zero status.

printf "${NOTE} - copying dotfiles\n"
folder=(
	ranger
	mpv
	alacritty
	btop
	cava
	hypr
	kitty
	Kvantum
	qt5ct
	qt6ct
	rofi
	swappy
	swaync
	swaylock
	wal
	waybar
	wlogout
	neofetch
	Thunar
	xfce4
)

for DIR in "${folder[@]}"; do
	DIRPATH=~/.config/"$DIR"
	if [ -d "$DIRPATH" ]; then
		echo -e "${NOTE} - Config for $DIR found, attempting to back up."
		BACKUP_DIR=$(get_backup_dirname)
		mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR"
		echo -e "${NOTE} - Backed up $DIR to $DIRPATH-backup-$BACKUP_DIR."
	fi
done

for DIRw in wallpapers; do
	DIRPATH=~/Pictures/"$DIRw"
	if [ -d "$DIRPATH" ]; then
		echo -e "${NOTE} - Wallpapers in $DIRw found, attempting to back up."
		BACKUP_DIR=$(get_backup_dirname)
		mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR"
		echo -e "${NOTE} - Backed up $DIRw to $DIRPATH-backup-$BACKUP_DIR."
	fi
done

printf "\n%.0s" {1..2}

# Copying config files
mkdir -p ~/.config
cp -r config/* ~/.config/ && { echo "${OK} Copy completed!"; } || {
	echo "${ERROR} Failed to copy config files."
}

# Copying wallpapers
mkdir -p ~/Pictures/wallpapers
cp -r wallpapers ~/Pictures/ && { echo "${OK} Copy completed!"; } || {
	echo "${ERROR} Failed to copy wallpapers."
}

# Copying 
cp assets/.ideavimrc ~ && { echo "${OK} Copy completed!"; } || {
	echo "${ERROR} Failed to copy .ideavimrc"
}

printf "\n%.0s" {1..2}

# Set some files as executable
chmod +x ~/.config/hypr/scripts/*
chmod +x ~/.config/hypr/boot.sh
printf "\n%.0s" {1..3}

# Detect machine type and set Waybar configurations accordingly, logging the output
if hostnamectl | grep -q 'Chassis: desktop'; then
	# Configurations for a desktop
	ln -sf "$HOME/.config/waybar/configs/default [TOP]" "$HOME/.config/waybar/config"
	rm -r "$HOME/.config/waybar/configs/default laptop [TOP]" "$HOME/.config/waybar/configs/default laptop [BOT]"
else
	# Configurations for a laptop or any system other than desktop
	ln -sf "$HOME/.config/waybar/configs/default laptop [TOP]" "$HOME/.config/waybar/config"
	rm -r "$HOME/.config/waybar/configs/default [TOP]" "$HOME/.config/waybar/configs/default [BOT]"
fi

printf "\n%.0s" {1..2}

# additional wallpapers
echo "$(tput setaf 6) By default only a few wallpapers are copied...$(tput sgr0)"
printf "\n%.0s" {1..2}

cd $HOME
if gum confirm "${CAT} Would you like to download additional wallpapers?"; then
	echo "${NOTE} Downloading additional wallpapers..."
	if git clone https://github.com/nhattruongNeoVim/wallpapers --depth 1; then
		echo "${NOTE} Wallpapers downloaded successfully."

		if cp -R wallpapers/wallpapers/* ~/Pictures/wallpapers/; then
			echo "${NOTE} Wallpapers copied successfully."
			rm -rf wallpapers
			break
		else
			echo "${ERROR} Copying wallpapers failed"
		fi
	else
		echo "${ERROR} Downloading additional wallpapers failed"
	fi
else
	echo "You chose not to download additional wallpapers."
fi

# symlinks for waybar style
ln -sf "$waybar_style" "$HOME/.config/waybar/style.css" &&

	# initialize pywal to avoid config error on hyprland
	wal -i $wallpaper -s -t

#initial symlink for Pywal Dark and Light for Rofi Themes
ln -sf "$HOME/.cache/wal/colors-rofi-dark.rasi" "$HOME/.config/rofi/pywal-color/pywal-theme.rasi"

printf "\n%.0s" {1..2}
printf "\n${OK} Copy Completed!\n\n\n"
printf "${ORANGE} ATTENTION!!!! \n"
printf "${ORANGE} YOU NEED to logout and re-login or reboot to avoid issues\n\n"
