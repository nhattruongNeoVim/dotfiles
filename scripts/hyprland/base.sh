#!/bin/bash
# base devel #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

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
			exit 1
		fi
	fi
}

base=(
	base-devel
)

extra=(
    starship
    tlp
    zsh
)

# Installation of main components
printf "\n%s - Installing components\n" "${NOTE}"

for PKG1 in "${base[@]}" "${extra[@]}"; do
	install_package_pacman "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
		exit 1
	fi
done

clear
