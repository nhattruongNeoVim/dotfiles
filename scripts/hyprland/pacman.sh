#!/bin/bash
# pacman adding up extra-spices

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
RESET=$(tput sgr0)

clear

echo -e "\e[34m   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____"
echo -e "  |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |     "
echo -e "  |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|     "
echo -e "  |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |     "
echo -e "  |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |     "
echo -e "  |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |     "
echo -e "  |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|     "
echo -e "                                                                                   "
echo -e "                                                                                   "
echo -e "-------------------- Script developed by nhattruongNeoVim --------------------     "
echo -e " -------------- Github: https://github.com/nhattruongNeoVim -----------------      "
echo

echo -e "${NOTE} Adding Extra Spice in pacman.conf ... ${RESET}"
pacman_conf="/etc/pacman.conf"

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

# updating pacman.conf
sudo pacman -Syyuu --noconfirm

# install requirement
printf "\n${NOTE} Install requirement...\n"
if pacman -Q gum &>/dev/null; then
	echo -e "${OK} gum is already installed. Skipping..."
else
	echo -e "${NOTE} Installing gum ..."
	sudo pacman -S --noconfirm gum
	if pacman -Q gum &>/dev/null; then
		echo -e "${OK} gum was installed."
	else
		echo -e "${ERROR} gum failed to install. You may need to install manually."
		echo "-> gum failed to install. You may need to install manually! Sorry I have tried :(" >>~/install.log
		exit 1
	fi
fi
