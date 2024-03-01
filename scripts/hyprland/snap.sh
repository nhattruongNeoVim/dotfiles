#!/bin/bash
# Snapd

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Check Existing snapd
cd ~
if [ -d snapd ]; then
	rm -rf snapd
fi

if [ -n snap ]; then
	printf "\n%s - Snap already installed, moving on.\n" "${OK}"
else
	printf "\n%s - Snap was NOT located\n" "${WARN}"
	printf "\n%s - Installing snap\n" "${NOTE}"
	git clone https://aur.archlinux.org/snapd.git || {
		printf "%s - Failed to clone snap from\n" "${ERROR}"
		exit 1
	}
	cd snapd || {
		printf "%s - Failed to enter snapd directory\n" "${ERROR}"
		exit 1
	}
	makepkg -si --noconfirm || {
		printf "%s - Failed to install snap\n" "${ERROR}"
		exit 1
	}
	cd ~ && rm -rf snap || {
		printf "%s - Failed to remove snapd directory\n" "${ERROR}"
		exit 1
	}
fi

# Setup snapd before proceeding
printf "\n%s - Set up snap.... \n" "${NOTE}"
sudo systemctl enable --now snapd.socket && sudo ln -s /var/lib/snapd/snap /snap && systemctl enable --now snapd.apparmor || {
	printf "%s - Failed to setup snap\n" "${ERROR}"
	exit 1
}

printf "\n%s - Install snap store.... \n" "${NOTE}"
snap install snap-store || {
	echo -e "\e[1A\e[K${ERROR} snap-store failed to install. You may need to install manually! Sorry I have tried :("
	echo "-> snap-store failed to install. You may need to install manually! Sorry I have tried :(" >>~/install.log
	exit 1
}
