#!/bin/bash
# Hyprland Packages

# source library
# source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)
BLUE=$(tput setaf 6)
PINK=$(tput setaf 213)

install_nala_package() {
    if sudo dpkg -l | grep -q -w "$1" &>/dev/null; then
        echo -e "${OK} $1 is already installed. Skipping..."
    else
        echo -e "${NOTE} Installing $1 ..."
        sudo nala install -y "$1"
        if sudo dpkg -l | grep -q -w "$1"; then
            echo -e "${OK} $1 was installed."
        else
            erMsg="${ERROR} $package failed to install. You may need to install manually! Sorry I have tried :("
            echo -e "$erMsg" && echo "-> $erMsg" >>"$HOME/install.log"
        fi
    fi
}
install_nala_package git
