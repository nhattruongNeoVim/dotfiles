#!/bin/bash
# Thunar #

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
			exit 1
		fi
	fi
}

thunar=(
	thunar
	thunar-volman
	tumbler
	ffmpegthumbnailer
	thunar-archive-plugin
)

# install thunar
printf "${NOTE} Installing Thunar Packages...\n"
for THUNAR in "${thunar[@]}"; do
	install_package "$THUNAR"
	[ $? -ne 0 ] && {
		echo -e "\e[1A\e[K${ERROR} - $THUNAR install had failed"
		exit 1
	}
done

# Move to thunar config file
cd ~
if [ -d dotfiles]; then
	cd dotfiles/config || {
		printf "%s - Failed to enter thunar config directory\n" "${ERROR}"
		exit 1
	}
else
	git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git ~/dotfiles --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
		exit 1
	}
fi

# Check for existing configs and copy if does not exist
for DIR1 in Thunar xfce4; do
	DIRPATH=~/.config/$DIR1
	if [ -d "$DIRPATH" ]; then
		echo -e "${NOTE} Config for $DIR1 found, no need to copy."
	else
		echo -e "${NOTE} Config for $DIR1 not found, copying from dotfiles."
		cp -r assets/$DIR1 ~/.config/ && echo "Copy $DIR1 completed!" || echo "Error: Failed to copy $DIR1 config files."
	fi
done

clear
