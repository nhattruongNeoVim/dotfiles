#!/bin/bash

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
	echo "This script should not be executed as root! Exiting......."
	exit 1
fi

clear

# author
echo -e "\e[34m   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____ "
echo -e "  |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |"
echo -e "  |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|"
echo -e "  |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |"
echo -e "  |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |"
echo -e "  |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |"
echo -e "  |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|"
echo -e ""
echo -e ""
echo -e "-------------------- Script developed by nhattruongNeoVim --------------------"
echo -e " -------------- Github: https://github.com/nhattruongNeoVim -----------------"
echo -e ""

# Welcome message
echo "$(tput setaf 166)ATTENTION: Run a full system update and Reboot first!! (Highly Recommended) $(tput sgr0)"
echo
echo "$(tput setaf 3)NOTE: You will be required to answer some questions during the installation! $(tput sgr0)"
echo
echo "$(tput setaf 3)NOTE: If you are installing on a VM, ensure to enable 3D acceleration else Hyprland wont start! $(tput sgr0)"
echo

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Function to colorize prompts
colorize_prompt() {
	local color="$1"
	local message="$2"
	echo -n "${color}${message}$(tput sgr0)"
}

# Function to ask a yes/no question and set the response in a variable
ask_yes_no() {
	if [[ ! -z "${!2}" ]]; then
		echo "$(colorize_prompt "$CAT" "$1 (Preset): ${!2}")"
		if [[ "${!2}" = [Yy] ]]; then
			return 0
		else
			return 1
		fi
	else
		eval "$2=''"
	fi
	while true; do
		read -p "$(colorize_prompt "$CAT" "$1 (y/n): ")" choice
		case "$choice" in
		[Yy]*)
			eval "$2='Y'"
			return 0
			;;
		[Nn]*)
			eval "$2='N'"
			return 1
			;;
		*) echo "Please answer with y or n." ;;
		esac
	done
}

# Function to ask a custom question with specific options and set the response in a variable
ask_custom_option() {
	local prompt="$1"
	local valid_options="$2"
	local response_var="$3"

	if [[ ! -z "${!3}" ]]; then
		return 0
	else
		eval "$3=''"
	fi

	while true; do
		read -p "$(colorize_prompt "$CAT" "$prompt ($valid_options): ")" choice
		if [[ " $valid_options " == *" $choice "* ]]; then
			eval "$response_var='$choice'"
			return 0
		else
			echo "Please choose one of the provided options: $valid_options"
		fi
	done
}

# Collect user responses to all questions
printf "\n"
ask_custom_option "-Type AUR helper" "paru or yay" aur_helper
printf "\n"
ask_yes_no "-Do you dual boot with window?" dual_boot
printf "\n"
ask_yes_no "-Do you want to set battery charging limit?" battery
printf "\n"
ask_yes_no "-Do you have any nvidia gpu in your system?" nvidia
printf "\n"
ask_yes_no "-Install GTK themes (required for Dark/Light function)?" gtk_themes
printf "\n"
ask_yes_no "-Do you want to configure Bluetooth?" bluetooth
printf "\n"
ask_yes_no "-Do you want to install Thunar file manager?" thunar
printf "\n"
ask_yes_no "-Install & configure SDDM log-in Manager plus (OPTIONAL) SDDM Theme?" sddm
printf "\n"
ask_yes_no "-Install XDG-DESKTOP-PORTAL-HYPRLAND? (For proper Screen Share ie OBS)" xdph
printf "\n"
ask_yes_no "-Do you want to download pre-configured Hyprland dotfiles?" dots
printf "\n"

# Check if dotfiles exist
cd ~
if [ -d dotfiles ]; then
	rm -rf dotfiles
fi

# Clone dotfile
if git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git ~/dotfiles --depth 1; then
	echo "Clone dotfile successfully"
fi
# Ensuring base-devel is installed
bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/base.sh)
sleep 0.5
bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/pacman.sh)

# Execute AUR helper script based on user choice
if [ "$aur_helper" == "paru" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/paru.sh)
elif [ "$aur_helper" == "yay" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/yay.sh)
fi

# Install hyprland packages
bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/hypr_pkgs.sh)
sleep 0.5
# Install pipewire and pipewire-audio
bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/pipewire.sh)

if [ "$dual_boot" == "Y" ]; then
	echo -e "${NOTE} I will set the local time on Ubuntu to display the correct time on Windows."
	timedatectl set-local-rtc 1 --adjust-system-clock
fi

if [ "$battery" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/battery.sh)
fi

if [ "$nvidia" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/nvidia.sh)
fi

if [ "$nvidia" == "N" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/hypr.sh)
fi

if [ "$gtk_themes" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/gtk_themes.sh)
fi

if [ "$bluetooth" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/bluetooth.sh)
fi

if [ "$thunar" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/thunar.sh)
fi

if [ "$sddm" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/sddm.sh)
fi

if [ "$xdph" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/xdph.sh)
fi

if [ "$dots" == "Y" ]; then
	bash <(curl -sSL https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/dotfiles.sh)
fi

if rm -rf ~/dotfiles; then
	echo -e "${NOTE} Remove dotfile successfully "
fi

printf "\n${OK} Yey! Installation Completed.\n"
printf "\n"
sleep 2
printf "\n${NOTE} You can start Hyprland by typing Hyprland (IF SDDM is not installed) (note the capital H!).\n"
printf "\n"
printf "\n${NOTE} It is highly recommended to reboot your system.\n\n"

read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

if [[ "$HYP" =~ ^[Yy]$ ]]; then
	if [[ "$nvidia" == "Y" ]]; then
		echo "${NOTE} NVIDIA GPU detected. Rebooting the system..."
		systemctl reboot
	else
		systemctl reboot
	fi
fi
