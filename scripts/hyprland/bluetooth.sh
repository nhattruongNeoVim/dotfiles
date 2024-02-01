#!/bin/bash
# Bluetooth Stuff #

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

# function for installing packages
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
			exit 1
		fi
	fi
}

bluetooth=(
	bluez
	bluez-utils
	blueman
)

# install bluetooth
printf "${NOTE} Installing Bluetooth Packages...\n"
for BLUE in "${bluetooth[@]}"; do
	install_package "$BLUE"
	[ $? -ne 0 ] && {
		echo -e "\e[1A\e[K${ERROR} - $BLUE install had failed"
		exit 1
	}
done

printf " Activating Bluetooth Services...\n"
sudo systemctl enable --now bluetooth.service
