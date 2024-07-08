#!/bin/bash

# check root
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

# init
clear

# start script
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
GUM_LINKDOWNLOADS="https://github.com/charmbracelet/gum/releases/latest/download/gum_${GUM_VERSION}_amd64.deb"

# update system
echo -e "$(tput setaf 3)[NOTE]$(tput sgr0) Update system... "
if sudo apt update && sudo apt upgrade; then
    echo -e "\n$(tput setaf 2)[OK]$(tput sgr0) Update system successfully\n"
else
    echo -e "\n$(tput setaf 1)[ERROR]$(tput sgr0) Failed to update your system\n"
fi

# install nala
echo -e "$(tput setaf 3)[NOTE]$(tput sgr0) Check nala..."
if ! command -v nala &>/dev/null; then
    echo -e "$(tput setaf 6)[ACTION]$(tput sgr0) Installing and initializing nala...\n"
    if sudo apt install nala -y && sudo nala update && sudo nala upgrade -y; then
        echo -e "\n$(tput setaf 3)[NOTE]$(tput sgr0) Press 1 2 3 and press Enter\n"
        sudo nala fetch
    else
        echo -e "\n$(tput setaf 1)[ERROR]$(tput sgr0) Failed to install nala\n"
    fi
else
    echo -e "$(tput setaf 2)[OK]$(tput sgr0) nala is already installed. Skipping...\n"
fi

# check ubuntu package manager
if command -v nala &>/dev/null; then
    PKGMN="nala"
elif command -v apt &>/dev/null; then
    PKGMN="apt"
fi

# package
pkgs=(
    curl
    wget
    git
    unzip
)

# install some required packages
printf "\n%s Installing required packages...\n" "$(tput setaf 3)[NOTE]$(tput sgr0)"
for PKG in "${pkgs[@]}"; do
    sudo $PKGMN install -y "$PKG"
    if [ $? -ne 0 ]; then
        echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) - $PKG install had failed"
    fi
done

# install gum (requirement)
printf "\n%s - Installing gum...\n" "$(tput setaf 3)[NOTE]$(tput sgr0)"
if cd /tmp && wget -qO gum.deb "$GUM_LINKDOWNLOADS"; then
    echo -e "$(tput setaf 2)[OK]$(tput sgr0) Download gum.deb successfully"
    if sudo $PKGMN install -y ./gum.deb; then
        echo -e "$(tput setaf 2)[OK]$(tput sgr0) Install gum successfully" && rm gum.deb && cd $HOME
    else
        echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) - gum install had failed"
    fi
else
    echo -e "$(tput setaf 1)[ERROR]$(tput sgr0) Failed to install gum"
fi
