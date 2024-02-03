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
			exit 1
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
		exit 1
	fi
done

# cd home
cd ~

# Check if the directory exists and delete it if present
if [ -d "GTK-themes-icons" ]; then
	echo "$NOTE Tokyo Theme GTK themes and Icons folder exist..deleting..."
	rm -rf "GTK-themes-icons"
fi

echo "$NOTE Cloning Tokyo Theme GTK themes and Icons repository..."
if git clone https://github.com/JaKooLit/GTK-themes-icons.git; then
	cd GTK-themes-icons
	chmod +x auto-extract.sh
	./auto-extract.sh
	cd ..
	echo "$OK Extracted GTK Themes & Icons to ~/.icons & ~/.themes folders"
else
	echo "$ERROR Download failed for Tokyo Theme GTK themes and Icons.." 
fi

cd ~
if rm -rf GTK-themes-icon.git; then
	echo "$OK Deleted GTK-themes-icons.git"
fi

# Check dotfiles
cd ~
if [ -d dotfiles]; then
	cd dotfiles || {
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

tar -xf "assets/Bibata-Modern-Ice.tar.xz" -C ~/.icons 
echo "$OK Extracted Bibata-Modern-Ice.tar.xz to ~/.icons folder." 
