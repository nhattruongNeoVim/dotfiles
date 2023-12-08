#!/bin/bash

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

# Function util
write_start() {
    echo -e "\e[32m>> $1\e[0m"
}

write_done() {
    echo -e "\e[34mDone\e[0m"
}

write_start "Start config"
write_start "Clone dotfiles..."
    git clone -b gnome https://github.com/nhattruongNeoVim/dotfiles ~ --depth 1
    cd ~
    rm ~/.zshrc ~/.ideavimrc
    rm -rf ~/.fonts ~/.icons ~/.themes
    rm -rf ~/.config/alacritty ~/.config/kitty ~/.config/neofetch ~/.config/ranger ~/.config/rofi ~/.config/tmux
    cd ~/dotfiles
    stow home
    fc-cache -fv
    cd ~/.themes/nhattruongNeoVimTheme
    mkdir -p ~/.config/gtk-4.0
    cp -rf gtk-4.0 ~/.config
write_done
