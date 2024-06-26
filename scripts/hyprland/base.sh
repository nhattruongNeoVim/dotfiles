#!/bin/bash
# pacman adding up extra-spices

# check root
if [[ $EUID -eq 0 ]]; then
	echo "This script should not be executed as root! Exiting......."
	exit 1
fi

# start script
clear
echo -e "\e[34m   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____"
echo -e " |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |      "
echo -e " |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|      "
echo -e " |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |      "
echo -e " |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |      "
echo -e " |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |      "
echo -e " |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|      "
echo -e "                                                                                   "
echo -e "                                                                                   "
echo -e "-------------------- Script developed by nhattruongNeoVim --------------------     "
echo -e " -------------- Github: https://github.com/nhattruongNeoVim -----------------      "
echo

echo -e "$(tput setaf 3)[NOTE]$(tput sgr0) Adding Extra Spice in pacman.conf ... "

# Variable
pacman_conf="/etc/pacman.conf"
mirrorlist="/etc/pacman.d/mirrorlist"

# Remove comments '#' from specific lines
lines_to_edit=(
	"Color"
	"CheckSpace"
	"VerbosePkgLists"
	"ParallelDownloads"
)

# Uncomment specified lines if they are commented out
for line in "${lines_to_edit[@]}"; do
	if grep -q "^#$line" "$pacman_conf"; then
		sudo sed -i "s/^#$line/$line/" "$pacman_conf"
		echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) Uncommented: $line"
	else
		echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) $line is already uncommented."
	fi
done

# Add "ILoveCandy" below ParallelDownloads if it doesn't exist
if grep -q "^ParallelDownloads" "$pacman_conf" && ! grep -q "^ILoveCandy" "$pacman_conf"; then
	sudo sed -i "/^ParallelDownloads/a ILoveCandy" "$pacman_conf"
	echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) Added ILoveCandy below ParallelDownloads."
else
	echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) ILoveCandy already exists"
fi

echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) Pacman.conf spicing up completed"

# Backup and update mirrorlist
# if sudo cp "$mirrorlist" "${mirrorlist}.bak"; then
# 	echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) Backup mirrorlist to mirrorlist.bak. $(tput sgr0)"
#     if sudo reflector --verbose --latest 10 --protocol https --sort rate --save "$mirrorlist"; then
# 	    echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) Updated mirrorlist. $(tput sgr0)"
#     else
#         echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) Failed to update mirrorlist. $(tput sgr0)"
#     fi
# else
# 	echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) Failed to backup mirrorlist. $(tput sgr0)"
# fi

# Updating pacman.conf
sudo pacman -Syyuu --noconfirm
if [ $? -ne 0 ]; then
	echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) Failed to update the package database."
fi

# Package
pkgs=(
	gum
	reflector
	curl
	git
	unzip
)

# Install requirement
printf "\n%s - Installing components\n" "$(tput setaf 3)[NOTE]$(tput sgr0)"
for PKG1 in "${pkgs[@]}"; do
	sudo pacman -S --noconfirm "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K$(tput setaf 1)[ERROR]$(tput sgr0) - $PKG1 install had failed"
	fi
done

clear
