#!/bin/bash
# XDG-Desktop-Portals #

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
			echo -e "\e[1A\e[K${ERROR} $1 failed to install :(. You may need to install manually! Sorry I have tried :("
			echo "-> $1 failed to install. You may need to install manually! Sorry I have tried :(" >>~/install.log
		fi
	fi
}

xdg=(
	xdg-desktop-portal-hyprland
	xdg-desktop-portal-gtk
)

# XDG-DESKTOP-PORTAL-HYPRLAND
for xdgs in "${xdg[@]}"; do
	install_package "$xdgs"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $xdph install had failed"
	fi
done

printf "\n"

printf "${NOTE} Checking for other XDG-Desktop-Portal-Implementations....\n"
sleep 1
printf "\n"
printf "${NOTE} XDG-desktop-portal-KDE & GNOME (if installed) should be manually disabled or removed! I can't remove it... sorry...\n"
while true; do
	if [[ -z $XDPH1 ]]; then
		read -rp "${CAT} Would you like to try to remove other XDG-Desktop-Portal-Implementations? (y/n) " XDPH1
	fi
	echo
	sleep 1

	case $XDPH1 in
	[Yy])
		# Clean out other portals
		printf "${NOTE} Clearing any other xdg-desktop-portal implementations...\n"
		# Check if packages are installed and uninstall if present
		if pacman -Qs xdg-desktop-portal-wlr >/dev/null; then
			echo "Removing xdg-desktop-portal-wlr..."
			sudo pacman -R --noconfirm xdg-desktop-portal-wlr
		fi
		if pacman -Qs xdg-desktop-portal-lxqt >/dev/null; then
			echo "Removing xdg-desktop-portal-lxqt..."
			sudo pacman -R --noconfirm xdg-desktop-portal-lxqt
		fi
		break
		;;
	[Nn])
		echo "no other XDG-implementations will be removed."
		break
		;;
	*)
		echo "Invalid input. Please enter 'y' for yes or 'n' for no."
		;;
	esac
done
