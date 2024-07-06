#!/bin/bash

# check root
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

# start script
clear
echo -e "\e[34m   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____"
echo -e " |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |      "
echo -e " |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|      "
echo -e " |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |      "
echo -e " |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |      "
echo -e " |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |      "
echo -e " |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|      "
echo -e "                                                                                   "
echo -e "                                                                                   "
echo -e "-------------------- Script developed by nhattruongNeoVim --------------------     "
echo -e " -------------- Github: https://github.com/nhattruongNeoVim -----------------      "
echo

GUM_VERSION="0.14.1"
RUNNING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)

# Script only run on GNOME
if $RUNNING_GNOME; then
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.session idle-delay 0
else
    echo "$(tput setaf 3)[NOTE]$(tput sgr0) This script is only available on Gnome, Exit."
    exit 1
fi

# update system
echo -e "$(tput setaf 3)[NOTE]$(tput sgr0) Update system... "
if sudo apt update && sudo apt upgrade; then
    echo -e "$(tput setaf 2)[OK]$(tput sgr0) Update system successfully"
else
    echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) Failed to update your system"
fi

# install nala
echo -e "$(tput setaf 3)[NOTE]$(tput sgr0) Check nala..."
if ! command -v nala &>/dev/null; then
    echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) Installing nala..."
    sudo apt install nala -y
else
    echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) Failed to install nala"
fi

# init nala
echo -e "$(tput setaf 3)[NOTE]$(tput sgr0) Initializing nala..."
if sudo nala update && sudo nala upgrade -y; then
    echo -e "$(tput setaf 3)[NOTE]$(tput sgr0) Press 1 2 3 and press Enter"
    sudo nala fetch
fi

# Package
pkgs=(
    curl
    wget
    git
    unzip
)

# install some required packages
printf "\n%s - Installing required packages...\n" "$(tput setaf 3)[NOTE]$(tput sgr0)"
for PKG1 in "${pkgs[@]}"; do
    sudo nala install -y "$PKG1"
    if [ $? -ne 0 ]; then
        echo -e "\e[1A\e[K$(tput setaf 1)[ERROR]$(tput sgr0) - $PKG1 install had failed"
    fi
done

cd /tmp
wget -qO gum.deb "https://github.com/charmbracelet/gum/releases/latest/download/gum_${GUM_VERSION}_amd64.deb"
sudo nala install -y ./gum.deb
if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K$(tput setaf 1)[ERROR]$(tput sgr0) - gum install had failed"
    exit 1
fi
rm gum.deb
cd -
