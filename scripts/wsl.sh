#!/bin/bash

clear
if hostnamectl | grep -q 'Ubuntu'; then
    bash <(curl -s https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/wsl/ubuntu.sh)
elif hostnamectl | grep -q 'Arch'; then
    bash <(curl -s https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/wsl/arch.sh)
fi
