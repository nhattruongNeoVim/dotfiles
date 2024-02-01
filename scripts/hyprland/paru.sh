#!/bin/bash
# Paru AUR Helper #
# NOTE: If yay is already installed, paru will not be installed #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# cd home
cd ~

# checking if paru-bin exist and removing if it is
if [ -d paru-bin ]; then
	rm -rf paru-bin
fi

# Check for AUR helper and install if not found
ISAUR=$(command -v yay || command -v paru)

if [ -n "$ISAUR" ]; then
	printf "\n%s - AUR helper already installed, moving on..\n" "${OK}"
else
	printf "\n%s - AUR helper was NOT located\n" "$WARN"
	printf "\n%s - Installing paru from AUR\n" "${NOTE}"
	git clone https://aur.archlinux.org/paru-bin.git || {
		printf "%s - Failed to clone paru from AUR\n" "${ERROR}"
		exit 1
	}
	cd paru-bin || {
		printf "%s - Failed to enter paru-bin directory\n" "${ERROR}"
		exit 1
	}
	makepkg -si --noconfirm || {
		printf "%s - Failed to install paru from AUR\n" "${ERROR}"
		exit 1
	}
    cd ~ && rm -rf paru-bin || {
		printf "%s - Failed to remove paru-bin directory\n" "${ERROR}"
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
