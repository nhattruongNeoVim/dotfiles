#!/bin/bash
# Main Hyprland Package #

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

hypr=(
	hyprland
)

# Removing other Hyprland to avoid conflict
printf "${YELLOW} Checking for other hyprland packages and remove if any..${RESET}\n"
if pacman -Qs hyprland >/dev/null; then
	printf "${YELLOW} Hyprland detected. uninstalling to install Hyprland-git...${RESET}\n"
	for hyprnvi in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
		sudo pacman -R --noconfirm "$hyprnvi" 2>/dev/null || true
	done
fi

# Hyprland
printf "${NOTE} Installing Hyprland .......\n"
for HYPR in "${hypr[@]}"; do
	install_package "$HYPR" 2>&1
	[ $? -ne 0 ] && {
		echo -e "\e[1A\e[K${ERROR} - $HYPR install had failed"
	}
done
