#!/bin/bash

if [[ $EUID -eq 0 ]]; then
	echo "This script should not be executed as root! Exiting......."
	exit 1
fi

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

colorize_prompt() {
	local color="$1"
	local message="$2"
	echo -n "${color}${message}$(tput sgr0)"
}

ask_yes_no() {
	if gum confirm "$CAT $1"; then
		eval "$2='Y'"
		echo "$CAT $1 $YELLOW Yes"
	else
		eval "$2='N'"
		echo "$CAT $1 $YELLOW No"
	fi
}

ask_custom_option() {
    if gum confirm "$CAT $1" --affirmative "$2" --negative "$3" ;then
		eval "$4=$2"
		echo "$CAT $1 $YELLOW ${!4}"
	else
		eval "$4=$3"
		echo "$CAT $1 $YELLOW ${!4}"
	fi
}

execute_script() {
	local script_url="https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/$1"
	bash <(curl -sSL "$script_url")
}

execute_script "pacman.sh"
sleep 0.5
clear

gum style \
	--foreground 213 --border-foreground 213 --border rounded \
	--align center --width 90 --margin "1 2" --padding "2 4" \
	"  ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____  " \
	" |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    | " \
	" |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __| " \
	" |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  | " \
	" |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ | " \
	" |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     | " \
	" |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_| " \
	"                                                                              " \
	" ------------------- Script developed by nhattruongNeoVim ------------------- " \
	"                                                                              " \
	"  -------------- Github: https://github.com/nhattruongNeoVim ---------------  " \
	"                                                                              "

gum style \
	--foreground 6 --border-foreground 6 --border rounded \
	--align left --width 105 --margin "1 2" --padding "2 4" \
	"NOTE: Ensure that you have a stable internet connection $(tput setaf 3)(Highly Recommended!!!!)" \
	"                                                                                               " \
	"NOTE: You will be required to answer some questions during the installation!!                  " \
	"                                                                                               " \
	"NOTE: If you are installing on a VM, ensure to enable 3D acceleration else Hyprland wont start!"

printf "\n"
ask_custom_option "Choose your AUR helper" "yay" "paru" aur_helper
printf "\n"
ask_yes_no "Do you dual boot with window?" dual_boot
printf "\n"
ask_yes_no "Do you want to install GTK themes?" gtk_themes
printf "\n"
ask_yes_no "Do you want to configure Bluetooth?" bluetooth
printf "\n"
ask_yes_no "Do you have any nvidia gpu in your system?" nvidia
printf "\n"
ask_yes_no "Do you want to install Thunar file manager?" thunar
printf "\n"
ask_yes_no "Do you want to install Snap (GUI packages manager)?" snap
printf "\n"
#ask_yes_no "Do you want to install & configure Firefox browser?" firefox
#printf "\n"
ask_yes_no "Do you want to install Homebrew (CLI package manager)?" homebrew
printf "\n"
ask_yes_no "Do you want to set battery charging limit (only for laptop)?" battery
printf "\n"
ask_yes_no "Install & configure SDDM log-in Manager plus (OPTIONAL) SDDM Theme?" sddm
printf "\n"
ask_yes_no "Install XDG-DESKTOP-PORTAL-HYPRLAND? (For proper Screen Share ie OBS)" xdph
printf "\n"
ask_yes_no "Do you want to download pre-configured Hyprland dotfiles?" dots
printf "\n"

printf "\n%.0s" {1..2}
if [ "$dual_boot" == "Y" ]; then
	echo -e "${CAT} I will set the local time on Arch to display the correct time on Windows.${RESET}"
	timedatectl set-local-rtc 1 --adjust-system-clock
fi

printf "\n%.0s" {1..2}
if [ "$battery" == "Y" ]; then
	execute_script "battery.sh"
fi

execute_script "swapfile.sh"
sleep 0.5
execute_script "pacman_pkgs.sh"

# Check if dotfiles exist
cd $HOME
if [ -d dotfiles ]; then
	rm -rf dotfiles
	echo -e "${OK} Remove dotfile successfully "
fi

# Clone dotfiles
printf "\n${NOTE} Clone dotfiles. "
if git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git --depth 1; then
	printf "\n${OK} Clone dotfiles succesfully.\n"
fi

if [ "$aur_helper" == "paru" ]; then
	execute_script "paru.sh"
elif [ "$aur_helper" == "yay" ]; then
	execute_script "yay.sh"
fi

execute_script "hypr_pkgs.sh"
sleep 0.5
execute_script "pipewire.sh"

if [ "$nvidia" == "Y" ]; then
	execute_script "nvidia.sh"
elif [ "$nvidia" == "N" ]; then
	execute_script "hypr.sh"
fi

if [ "$gtk_themes" == "Y" ]; then
	execute_script "gtk_themes.sh"
fi

if [ "$bluetooth" == "Y" ]; then
	execute_script "bluetooth.sh"
fi

if [ "$thunar" == "Y" ]; then
	execute_script "thunar.sh"
fi

if [ "$thunar" == "Y" ]; then
	execute_script "snap.sh"
fi

if [ "$homebrew" == "Y" ]; then
	execute_script "homebrew.sh"
fi

#if [ "$firefox" == "Y" ]; then
#	execute_script "firefox.sh"
#fi

if [ "$sddm" == "Y" ]; then
	execute_script "sddm.sh"
fi

if [ "$xdph" == "Y" ]; then
	execute_script "xdph.sh"
fi

if [ "$dual_boot" == "Y" ]; then
	execute_script "grub_themes.sh"
fi

execute_script "input_group.sh"

if [ "$dots" == "Y" ]; then
	execute_script "dotfiles.sh"
fi

cd ~
if [ -d dotfiles ]; then
	rm -rf dotfiles
	echo -e "${NOTE} Remove dotfile successfully "
fi

printf "\n%.0s" {1..2}

if [ -f $HOME/install.log ]; then
	if gum confirm "${CAT} Do you want to check log?"; then
		if pacman -Q bat &>/dev/null; then
			cat_command="bat"
		else
			cat_command="cat"
		fi
		$cat_command $HOME/install.log
	fi
fi

printf "\n%.0s" {1..2}
printf "\n${OK} Yey! Installation Completed.\n"
printf "\n%.0s" {1..2}
printf "\n${NOTE} You can start Hyprland by typing Hyprland (IF SDDM is not installed) (note the capital H!).\n"
printf "\n${NOTE} It is highly recommended to reboot your system.\n\n"

if gum confirm "${CAT} Would you like to reboot now?"; then
	if [[ "$nvidia" == "Y" ]]; then
		echo "${NOTE} NVIDIA GPU detected. Rebooting the system..."
		systemctl reboot
	else
		systemctl reboot
	fi
fi
