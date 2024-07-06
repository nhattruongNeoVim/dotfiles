#!/bin/bash
# Packages

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

pkgs=(
    neofetch
    xclip
    zsh
    kitty
    bat
    rofi
    ibus-unikey
    default-jdk
    htop
    stow
    fzf
    make
    ripgrep
    cmake
    aria2
    pip
    tmux
    libsecret-tools
    cava
    net-tools
    unzip
    lolcat
    cpufetch
    bpytop
    figlet
    sl
    cmatrix
    trash-cli
    ranger
    hollywood
    python3.11-venv
    grub-customizer
    python3-neovim
)

printf "\n%s - Installing packages.... \n" "${NOTE}"
for PKG1 in "${dependencies[@]}"; do
    install_package "$PKG1"
    if [ $? -ne 0 ]; then
        echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the script."
        exit 1
    fi
done

printf "\n%s - Installing starship.... \n" "${NOTE}"
if curl -sS https://starship.rs/install.sh | sh; then
    printf "\n%s - Starship was installed \n" "${OK}"
fi
