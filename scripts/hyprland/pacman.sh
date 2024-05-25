#!/bin/bash
# pacman adding up extra-spices

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

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

echo -e "${NOTE} Adding Extra Spice in pacman.conf ... ${RESET}"

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
		echo -e "${CAT} Uncommented: $line ${RESET}"
	else
		echo -e "${CAT} $line is already uncommented. ${RESET}"
	fi
done

# Add "ILoveCandy" below ParallelDownloads if it doesn't exist
if grep -q "^ParallelDownloads" "$pacman_conf" && ! grep -q "^ILoveCandy" "$pacman_conf"; then
	sudo sed -i "/^ParallelDownloads/a ILoveCandy" "$pacman_conf"
	echo -e "${CAT} Added ILoveCandy below ParallelDownloads. ${RESET}"
else
	echo -e "${CAT} ILoveCandy already exists ${RESET}"
fi

echo -e "${CAT} Pacman.conf spicing up completed ${RESET}"

# Backup and update mirrorlist
if sudo cp "$mirrorlist" "${mirrorlist}.bak"; then
	echo -e "${CAT} Backup mirrorlist to mirrorlist.bak. ${RESET}"
    if sudo reflector --verbose --latest 10 --protocol https --sort rate --save "$mirrorlist"; then
	    echo -e "${CAT} Updated mirrorlist. ${RESET}"
    else
        echo -e "${ERROR} Failed to update mirrorlist. ${RESET}"
    fi
else
	echo -e "${ERROR} Failed to backup mirrorlist. ${RESET}"
fi

# Updating pacman.conf
sudo pacman -Syyuu --noconfirm

# Package
pkgs=(
    gum
    reflector
)

# Install requirement
printf "\n%s - Installing components\n" "${NOTE}"
for PKG1 in "${pkgs[@]}"; do
	install_pacman_pkg "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done
