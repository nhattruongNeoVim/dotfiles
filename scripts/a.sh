#!/bin/bash

ask_yes_no() {
	if gum confirm "$1"; then
		eval "$2='Y'"
	else
		eval "$2='N'"
	fi
}

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
#ask_yes_no "-Do you want to install & configure Firefox browser?" firefox
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
