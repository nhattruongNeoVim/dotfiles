#!/bin/bash

# source library
# source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

if command -v nala &>/dev/null; then
    PKGMN="nala"
elif command -v apt &>/dev/null; then
    PKGMN="apt"
fi

# function to install nala packages
install_nala_package() {
    if dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "installed"; then
        echo -e "${OK} $1 is already installed. Skipping..."
    else
        echo -e "${NOTE} Installing $1 ..."
        sudo $PKGMN install -y "$1"
        if dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "installed"; then
            echo -e "${OK} $1 was installed."
        else
            erMsg="${ERROR} $1 failed to install. You may need to install manually! Sorry I have tried :("
            echo -e "$erMsg" && echo "-> $erMsg" >>"$HOME/install.log"
        fi
    fi
}


install_nala_package nala
