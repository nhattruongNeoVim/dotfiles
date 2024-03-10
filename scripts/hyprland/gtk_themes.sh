#!/bin/bash
# GTK Themes & ICONS and  Sourcing from a different Repo #

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

engine=(
	unzip
	gtk-engine-murrine
)

# installing engine needed for gtk themes
for PKG1 in "${engine[@]}"; do
	install_package "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\033[1A\033[K${ERROR} - $PKG1 install had failed"
	fi
done

# Check dotfiles
cd ~
if [ -d dotfiles ]; then
	cd dotfiles || {
		printf "%s - Failed to cd dotfiles directory\n" "${ERROR}"
		exit 1
	}
else
	printf "\n${NOTE} Clone dotfiles. " && git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git ~/dotfiles --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
		exit 1
	}
fi

# Copy gtk_themes file
printf "\n%.0s" {1..2}
printf "${NOTE} - Copying gtk themes file\n"

# copying icon
mkdir -p ~/.icons
cp -r assets/.icons/* ~/.icons/ && { echo "${OK}Copy icons completed!"; } || {
	echo "${ERROR} Failed to copy icons files."
}

# copying font
mkdir -p ~/.fonts
cp -r assets/.fonts/* ~/.fonts/ && { echo "${OK}Copy fonts completed!"; } || {
	echo "${ERROR} Failed to copy fonts files."
}

# copying theme
mkdir -p ~/.themes
cp -r assets/.themes/* ~/.themes && { echo "${OK}Copy themes completed!"; } || {
	echo "${ERROR} Failed to copy themes files."
}

# reload fonts
printf "\n%.0s" {1..2}
fc-cache -fv
