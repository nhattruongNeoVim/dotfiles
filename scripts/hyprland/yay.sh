#!/bin/bash
# Yay AUR Helper #
# NOTE: If paru is already installed, yay will not be installed #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Check Existing yay-bin
cd ~
if [ -d yay-bin ]; then
	rm -rf yay-bin
fi

# Check for AUR helper and install if not found
ISAUR=$(command -v yay || command -v paru)

if [ -n "$ISAUR" ]; then
	printf "\n%s - AUR helper already installed, moving on.\n" "${OK}"
else
	printf "\n%s - AUR helper was NOT located\n" "${WARN}"
	printf "\n%s - Installing yay from AUR\n" "${NOTE}"
	git clone https://aur.archlinux.org/yay-bin.git || {
		printf "%s - Failed to clone yay from AUR\n" "${ERROR}"
		exit 1
	}
	cd yay-bin || {
		printf "%s - Failed to enter yay-bin directory\n" "${ERROR}"
		exit 1
	}
	makepkg -si --noconfirm || {
		printf "%s - Failed to install yay from AUR\n" "${ERROR}"
		exit 1
	}
    cd ~ && rm -rf yay-bin || {
		printf "%s - Failed to remove yay-bin directory\n" "${ERROR}"
		exit 1
    }
fi

# Update system before proceeding
printf "\n%s - Performing a full system update to avoid issues.... \n" "${NOTE}"
ISAUR=$(command -v yay || command -v paru)

$ISAUR -Syu --noconfirm || {
	printf "%s - Failed to update system\n" "${ERROR}"
	exit 1
}
