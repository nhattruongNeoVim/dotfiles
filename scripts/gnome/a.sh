#!/bin/bash

# Colors for terminal output
OK=$(tput setaf 2)[OK]$(tput sgr0)
ERROR=$(tput setaf 1)[ERROR]$(tput sgr0)
NOTE=$(tput setaf 3)[NOTE]$(tput sgr0)
ACTION=$(tput setaf 6)[ACTION]$(tput sgr0)

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

# Function to install packages
install_package() {
    local package_manager=$1
    local package_name=$2

    if $package_manager install -y "$package_name"; then
        echo -e "${OK} Installed: $package_name"
    else
        echo -e "${ERROR} Failed to install: $package_name"
        return 1
    fi
}

# Function to update system
update_system() {
    echo -e "${NOTE} Updating system..."
    if sudo apt update && sudo apt upgrade -y; then
        echo -e "${OK} System updated successfully"
    else
        echo -e "${ERROR} Failed to update system"
        return 1
    fi
}

# Function to install nala
install_nala() {
    echo -e "${NOTE} Checking nala..."
    if ! command -v nala &>/dev/null; then
        echo -e "${ACTION} Installing and initializing nala..."
        if sudo apt install nala -y && sudo nala update && sudo nala upgrade -y; then
            echo -e "${OK} nala installed and initialized successfully"
            sudo nala fetch
        else
            echo -e "${ERROR} Failed to install nala"
            return 1
        fi
    else
        echo -e "${OK} nala is already installed. Skipping..."
    fi
}

# Function to install required packages
install_required_packages() {
    local package_manager=$1
    local packages=(
        curl
        wget
        git
        unzip
    )

    echo -e "${NOTE} Installing required packages..."
    for pkg in "${packages[@]}"; do
        install_package "$package_manager" "$pkg" || echo -e "${ERROR} - $pkg installation failed"
    done
}

# Function to install gum package
install_gum() {
    local gum_version="0.14.1"
    local gum_download_link="https://github.com/charmbracelet/gum/releases/latest/download/gum_${gum_version}_amd64.deb"

    echo -e "${NOTE} Installing gum..."
    if cd /tmp && wget -qO gum.deb "$gum_download_link"; then
        echo -e "${OK} Downloaded gum.deb successfully"
        if sudo $package_manager install -y ./gum.deb; then
            echo -e "${OK} Installed gum successfully"
            rm gum.deb && cd "$HOME"
        else
            echo -e "${ERROR} Failed to install gum"
            return 1
        fi
    else
        echo -e "${ERROR} Failed to download gum"
        return 1
    fi
}

# Main script flow
clear
echo -e "\e[34m   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____"
echo -e " |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |"
echo -e " |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|"
echo -e " |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |"
echo -e " |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |"
echo -e " |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |"
echo -e " |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|"
echo -e "                                                                                   "
echo -e "                                                                                   "
echo -e "-------------------- Script developed by nhattruongNeoVim --------------------"
echo -e " -------------- Github: https://github.com/nhattruongNeoVim -----------------"
echo

# Run functions
update_system || exit 1
install_nala || exit 1
install_required_packages "$PKGMN" || exit 1
install_gum || exit 1

echo -e "\n$(tput setaf 2)[OK]$(tput sgr0) All operations completed successfully!"
