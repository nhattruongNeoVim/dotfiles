#!/bin/bash
# config wsl

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# require
exScriptGnome "boot.sh"

# init
clear

# start script
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
    --align left --width 90 --margin "1 2" --padding "2 4" \
    "$(tput setaf 3)NOTE:$(tput setaf 6) Ensure that you have a stable internet connection $(tput setaf 3)(Highly Recommended!!!!)$(tput sgr0)" \
    "                                                                                                                             $(tput sgr0)" \
    "$(tput setaf 3)NOTE:$(tput setaf 6) You will be required to answer some questions during the installation!!                  $(tput sgr0)" \
    "                                                                                                                             $(tput sgr0)" \
    "$(tput setaf 3)NOTE:$(tput setaf 6) If you are installing on a VM, ensure to enable 3D acceleration!                         $(tput sgr0)"

# fix DNS
printf "\n%s - Fix DNS to 8.8.8.8 \n" "${NOTE}"
if grep -q "nameserver" "/etc/resolv.conf"; then
    if sudo sed -i 's/nameserver.*/nameserver 8.8.8.8/' "/etc/resolv.conf"; then
        printf "\n%s - Fix DNS successfully \n" "${OK}"
    else
        printf "\n%s - Failed to fix DNS \n" "${ERROR}"
    fi
fi

# configure /etc/wsl.conf
printf "\n%s - Configuring /etc/wsl.conf \n" "${NOTE}"
if ! grep -q "\[network\]" "/etc/wsl.conf"; then
    if echo -e "\n[network]\ngenerateResolvConf = false" | sudo tee -a "/etc/wsl.conf" >/dev/null; then
        printf "\n%s - Added network configuration to /etc/wsl.conf \n" "${OK}"
    else
        printf "\n%s - Failed to add network configuration to /etc/wsl.conf \n" "${ERROR}"
    fi
fi

# list packages
pkgs=(
    build-essential
    python3
    python3-pip
    neofetch
    xclip
    zsh
    bat
    default-jdk
    htop
    fzf
    make
    ripgrep
    cmake
    tmux
    cava
    net-tools
    lolcat
    sl
    ca-certificates
    gnupg
    ranger
    unzip
    python3.10-venv
    python3-neovim
)

# install packages
printf "\n%s - Install packages.... \n" "${NOTE}"
for PKG in "${pkgs[@]}"; do
    install_ubuntu_packages "$PKG"
    if [ $? -ne 0 ]; then
        printf "\n%s - $PKG install had failed, please check the script. \n" "${ERROR}"
    fi
done

if command -v node &>/dev/null; then
    printf "\n%s - Node already installed, moving on \n" "${OK}"
else
    printf "\n%s - Install Node.js .... \n" "${NOTE}"
    if curl -fsSL "$NODEJS" -o nodesource_setup.sh; then
        printf "\n%s - Download the Node.js setup script successfully \n" "${OK}"
        if sudo -E bash nodesource_setup.sh && sudo $PKGMN install -y nodejs; then
            printf "\n%s - Install Node.js successfully \n" "${OK}"
        else
            printf "\n%s - Install Node.js had failed \n" "${ERROR}"
        fi
    else
        printf "\n%s - Download the Node.js setup script had failed \n" "${ERROR}"
    fi
fi

if command -v rustc &>/dev/null; then
    printf "\n%s - Rust already installed, moving on \n" "${OK}"
else
    printf "\n%s - Install Rust ... \n" "${NOTE}"
    if curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh; then
        printf "%s - Rust was installed \n" "${OK}"
        source $HOME/.cargo/env
    else
        printf "\n%s - Rust install had failed \n" "${ERROR}"
    fi
fi

if command -v lsd &>/dev/null; then
    printf "\n%s - Lsd already installed, moving on \n" "${OK}"
else
    printf "\n%s - Install lsd ... \n" "${NOTE}"
    if cargo install lsd --locked; then
        printf "%s - Lsd was installed \n" "${OK}"
    else
        printf "\n%s - Lsd install had failed \n" "${ERROR}"
    fi
fi

if command -v starship &>/dev/null; then
    printf "\n%s - Starship already installed, moving on \n" "${OK}"
else
    printf "\n%s - Install starship ... \n" "${NOTE}"
    if cargo install starship --locked; then
        printf "%s - Starship was installed \n" "${OK}"
    else
        printf "\n%s - Starship install had failed \n" "${ERROR}"
    fi
fi

if command -v arttime &>/dev/null; then
    printf "\n%s - Arttime already installed, moving on \n" "${OK}"
else
    printf "\n%s - Installing arttime .... \n" "${NOTE}"
    if wget -O /tmp/arttime.deb "$ARTTIME"; then
        printf "\n%s - Download arttime.deb successfully.... \n" "${OK}"
        if sudo $PKGMN install -y /tmp/arttime.deb; then
            printf "\n%s - Install arttime successfully \n" "${OK}"
        else
            printf "\n%s - Arttime install had failed \n" "${ERROR}"
        fi
    else
        printf "\n%s - Failed to install arttime.deb \n" "${ERROR}"
    fi
fi

if command -v colorscript &>/dev/null; then
    printf "\n%s - Colorscript already installed, moving on \n" "${OK}"
else
    printf "\n%s - Installing colorscript .... \n" "${NOTE}"
    if git clone "$COLORSCRIPT" /tmp/colorscript; then
        printf "\n%s - Clone shell-color-scripts successfully \n" "${OK}"
        if
            cd /tmp/colorscript &&
                sudo make install &&
                sudo cp completions/_colorscript /usr/share/zsh/site-functions &&
                cd - &>/dev/null
        then
            printf "\n%s - Install shell-color-scripts successfully \n" "${OK}"
        else
            printf "\n%s - Failed to install shell-color-scripts \n" "${ERROR}"
        fi
    else
        printf "\n%s - Failed to clone shell-color-scripts repository \n" "${ERROR}"
    fi
fi

if command -v pipes.sh &>/dev/null; then
    printf "\n%s - Pipes.sh already installed, moving on.\n" "${OK}"
else
    printf "\n%s - Install pipes.sh ... \n" "${NOTE}"
    if git clone "$PIPES" /tmp/pipes.sh; then
        printf "\n%s - Clone pipe.sh successfully \n" "${OK}"
        if
            cd /tmp/pipes.sh &&
                make PREFIX=$HOME/.local install &&
                cd - &>/dev/null
        then
            printf "\n%s - Install pipes.sh successfully \n" "${OK}"
        else
            printf "\n%s - Failed to install pipes.sh \n" "${ERROR}"
        fi
    else
        printf "\n%s - Failed to clone pipe.sh repository \n" "${ERROR}"
    fi
fi

if command -v lazygit &>/dev/null; then
    printf "\n%s - Lazygit already installed, moving on.\n" "${OK}"
else
    printf "\n%s - Install lazygit ... \n" "${NOTE}"
    if wget -O /tmp/lazygit.tar.gz "$LAZYGIT" && tar -xf lazygit.tar.gz lazygit; then
        printf "\n%s - Download lazygit.tar successfully \n" "${OK}"
        if sudo install /tmp/lazygit /usr/local/bin; then
            printf "\n%s - Install lazygit successfully \n" "${OK}"
        else
            printf "\n%s - Failed to install lazygit \n" "${ERROR}"
        fi
    fi
fi

printf "\n%s - Install neovim ... \n" "${NOTE}"
if command -v nvim &>/dev/null; then
    sudo $PKGMN remove neovim -y
fi
if wget -O /tmp/nvim-linux64.tar.gz "$NEOVIM"; then
    printf "\n%s - Download lastest version neovim successfully \n" "${OK}"
    mkdir -p $HOME/.local/bin &&
        mv /tmp/nvim-linux64.tar.gz $HOME/.local/bin &&
        tar -xf $HOME/.local/bin/nvim-linux64.tar.gz -C $HOME/.local/bin &&
        rm -fr $HOME/.local/bin/nvim-linux64.tar.gz &&
        ln -s $HOME/.local/bin/nvim-linux64/bin/nvim $HOME/.local/bin/nvim &&
        printf "\n%s - Install neovim successfully \n" "${OK}" || {
        printf "\n%s - Failed to install neovim \n" "${ERROR}"
    }
else
    printf "\n%s - Failed to download neovim \n" "${ERROR}"
fi

# clone dotfiles
cd $HOME
if [ -d dotfiles ]; then
    cd dotfiles || {
        printf "%s - Failed to enter dotfiles config directory\n" "${ERROR}"
        exit 1
    }
else
    printf "\n${NOTE} Clone dotfiles. " && git clone -b gnome https://github.com/nhattruongNeoVim/dotfiles.git ~/dotfiles --depth 1 || {
        printf "%s - Failed to clone dotfiles \n" "${ERROR}"
        exit 1
    }
    cd dotfiles || {
        printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
        exit 1
    }
fi

printf "\n%s - Start config .... \n" "${NOTE}"

folder=(
    neofetch
    ranger
    tmux
    starship.toml
)

# back up configuration file
for DIR in "${folder[@]}"; do
    DIRPATH=~/.config/"$DIR"
    if [ -d "$DIRPATH" ]; then
        echo -e "${NOTE} - Config for $DIR found, attempting to back up."
        BACKUP_DIR=$(get_backup_dirname)
        mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR"
        echo -e "${NOTE} - Backed up $DIR to $DIRPATH-backup-$BACKUP_DIR."
    fi
done

# copying configuration file
for ITEM in "${folder[@]}"; do
    if [[ -d "config/$ITEM" ]]; then
        cp -r "config/$ITEM" ~/.config/ && echo "${OK} Copy completed" || echo "${ERROR} Failed to copy config files."
    elif [[ -f "config/$ITEM" ]]; then
        cp "config/$ITEM" ~/.config/ && echo "${OK} Copy completed" || echo "${ERROR} Failed to copy config files."
    fi
done

# Copying other
cp assets/.zshrc ~ && cp assets/.ideavimrc ~ && { echo "${OK} Copy completed"; } || {
    echo "${ERROR} Failed to copy .zshrc && .ideavimrc"
}

# Copying font
mkdir -p ~/.fonts
cp -r assets/.fonts/* ~/.fonts/ && { echo "${OK} Copy fonts completed"; } || {
    echo "${ERROR} Failed to copy fonts files."
}

# Reload fonts
printf "\n%.0s" {1..2}
fc-cache -fv

# Clone tpm
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "${NOTE} TPM (Tmux Plugin Manager) is already installed."
else
    # Clone TPM repository
    echo "${NOTE} Cloning TPM (Tmux Plugin Manager)..."
    if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth 1; then
        echo "${OK} TPM (Tmux Plugin Manager) cloned successfully"
    else
        echo "${ERROR} Failed to clone TPM (Tmux Plugin Manager)."
    fi
fi

# Remove dotfiles
cd $HOME
if [ -d dotfiles ]; then
    rm -rf dotfiles
    echo -e "${NOTE} Remove dotfile successfully "
fi

# Chang shell to zsh
printf "\n${NOTE} Change shell to zsh\n"
chsh -s $(which zsh)

printf "\n%.0s" {1..2}
printf "\n${OK} Yey! Setup Completed.\n"
printf "\n%.0s" {1..2}

zsh
