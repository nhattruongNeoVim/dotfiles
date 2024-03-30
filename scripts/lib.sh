#!/bin/bash
# library for arch 

# check root
if [[ $EUID -eq 0 ]]; then
	echo "This script should not be executed as root! Exiting......."
	exit 1
fi

# set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# function to install pacman package
install_pacman_pkg() {
	if pacman -Q "$1" &>/dev/null; then
		echo -e "${OK} $1 is already installed. Skipping..."
	else
		echo -e "${NOTE} Installing $1 ..."
		sudo pacman -Sy --noconfirm "$1"
		if pacman -Q "$1" &>/dev/null; then
			echo -e "${OK} $1 was installed."
		else
			echo -e "${ERROR} $1 failed to install. You may need to install manually."
			echo "-> $1 failed to install. You may need to install manually! Sorry I have tried :(" >>$HOME/install.log
		fi
	fi
}

# function to uninstall pacman package
uninstall_pacman_pkg() {
	if pacman -Qi "$1" &>>/dev/null; then
		echo -e "${NOTE} Uninstalling $1 ..."
		sudo pacman -Rns --noconfirm "$1"
		if ! pacman -Qi "$1" &>>/dev/null; then
			echo -e "\e[1A\e[K${OK} $1 was uninstalled."
		else
			echo -e "\e[1A\e[K${ERROR} $1 failed to uninstall"
			echo "-> $1 failed to uninstall" >>$HOME/install.log
		fi
	fi
}

# AUR
ISAUR=$(command -v yay || command -v paru)

# function to install aur package
install_aur_pkg() {
	if $ISAUR -Q "$1" &>>/dev/null; then
		echo -e "${OK} $1 is already installed. Skipping..."
	else
		echo -e "${NOTE} Installing $1 ..."
		$ISAUR -Sy --noconfirm "$1"
		if $ISAUR -Q "$1" &>>/dev/null; then
			echo -e "\e[1A\e[K${OK} $1 was installed."
		else
			echo -e "\e[1A\e[K${ERROR} $1 failed to install :(. You may need to install manually! Sorry I have tried :("
			echo "-> $1 failed to install. You may need to install manually! Sorry I have tried :(" >>$HOME/install.log
		fi
	fi
}

# function to ask and return yes no
ask_yes_no() {
	if gum confirm "$CAT $1"; then
		eval "$2='Y'"
		echo "$CAT $1 $YELLOW Yes"
	else
		eval "$2='N'"
		echo "$CAT $1 $YELLOW No"
	fi
}

# function to ask and return custom answer
ask_custom_option() {
    if gum confirm "$CAT $1" --affirmative "$2" --negative "$3" ;then
		eval "$4=$2"
		echo "$CAT $1 $YELLOW ${!4}"
	else
		eval "$4=$3"
		echo "$CAT $1 $YELLOW ${!4}"
	fi
}

# function to execute hyprland script
exScriptHypr() {
	local script_url="https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/$1"
	bash <(curl -sSL "$script_url")
}

# function to execute wsl script
exScriptWsl() {
	local script_url="https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/wsl/$1"
	bash <(curl -sSL "$script_url")
}
