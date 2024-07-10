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

# install colorscript
cd $HOME || exit 1
printf "\n%.0s" {1..2}
if [ -d shell-color-scripts ]; then
    rm -rf shell-color-scripts
fi

if command -v colorscript &>/dev/null; then
    printf "\n%s - Colorscript already installed, moving on.\n" "${OK}"
else
    printf "\n%s - Colorscript was NOT located\n" "${NOTE}"
    printf "\n%s - Installing colorscript\n" "${NOTE}"
    git clone https://gitlab.com/dwt1/shell-color-scripts.git --depth 1 || {
        printf "%s - Failed to clone colorscript\n" "${ERROR}"
        exit 1
    }
    cd shell-color-scripts || {
        printf "%s - Failed to enter colorscript directory\n" "${ERROR}"
        exit 1
    }
    sudo make install && sudo cp completions/_colorscript /usr/share/zsh/site-functions || {
        printf "%s - Failed to install colorscript\n" "${ERROR}"
        exit 1
    }
    cd .. && rm -rf shell-color-scripts || {
        printf "%s - Failed to remove colorscript directory\n" "${ERROR}"
        exit 1
    }
fi

# Install colorscript
cd $HOME || exit 1
printf "\n%.0s" {1..2}
if [ -d pokemon-colorscripts ]; then
    rm -rf pokemon-colorscripts
fi

if command -v pokemon-colorscripts &>/dev/null; then
    printf "\n%s - Pokemon colorscript already installed, moving on.\n" "${OK}"
else
    printf "\n%s - Pokemon Colorscript was NOT located\n" "${NOTE}"
    printf "\n%s - Installing Pokemon colorscript\n" "${NOTE}"
    git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git --depth 1 || {
        printf "%s - Failed to clone pokemon-colorscripts\n" "${ERROR}"
        exit 1
    }
    cd pokemon-colorscripts || {
        printf "%s - Failed to enter colorscript directory\n" "${ERROR}"
        exit 1
    }
    sudo ./install.sh || {
        printf "%s - Failed to install colorscript\n" "${ERROR}"
        exit 1
    }
    cd .. && rm -rf pokemon-colorscripts || {
        printf "%s - Failed to remove colorscript directory\n" "${ERROR}"
        exit 1
    }
fi

# Install pipes.sh
cd $HOME || exit 1
printf "\n%.0s" {1..2}
if [ -d pipes.sh ]; then
    rm -rf pipes.sh
fi

if command -v pipes.sh &>/dev/null; then
    printf "\n%s - Pipes.sh already installed, moving on.\n" "${OK}"
else
    printf "\n%s - Pipes.sh was NOT located\n" "${NOTE}"
    printf "\n%s - Installing pipes.sh\n" "${NOTE}"
    git clone https://github.com/pipeseroni/pipes.sh --depth 1 || {
        printf "%s - Failed to clone pipes.sh\n" "${ERROR}"
        exit 1
    }
    cd pipes.sh || {
        printf "%s - Failed to enter pipes.sh directory\n" "${ERROR}"
        exit 1
    }
    make PREFIX=$HOME/.local install || {
        printf "%s - Failed to install pipes.sh\n" "${ERROR}"
        exit 1
    }
    cd .. && rm -rf pipes.sh || {
        printf "%s - Failed to remove pipes.sh directory\n" "${ERROR}"
        exit 1
    }
fi

# Install and initial rust
printf "\n%.0s" {1..2}
printf "\n${NOTE} Installing rust...\n"
if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh; then
    printf "\n${OK} Install rust successfully\n"
else
    printf "\n${ERROR} Failed to install rust\n"
fi
printf "\n%.0s" {1..2}
if source $HOME/.cargo/env && cargo --version; then
    printf "\n${OK} Initial rust successfully\n"
else
    printf "\n${ERROR} Failed to initial rust\n"
fi

# Install cargo packages
printf "\n%.0s" {1..2}
printf "\n${NOTE} Installing lsd, starship ...\n"
if cargo install lsd --locked && cargo install starship --locked; then
    printf "\n${OK} Install lsd, starship successfully\n"
else
    printf "\n${ERROR} Failed to install lsd, starship\n"
fi

# Install nodejs
printf "\n%.0s" {1..2}
printf "\n${NOTE} Installing nodejs...\n"
if curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh && sudo -E bash nodesource_setup.sh && sudo nala install -y nodejs; then
    rm nodesource_setup.sh
    printf "\n${OK} Install nodejs successfully\n"
else
    printf "\n${ERROR} Failed to install nodejs\n"
fi

# Install lazygit
printf "\n%.0s" {1..2}
printf "\n${NOTE} Installing lazygit...\n"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit && rm -fr lazygit.tar.gz
if sudo install lazygit /usr/local/bin && rm -rf lazygit; then
    printf "\n${OK} Install lazygit successfully\n"
else
    printf "\n${ERROR} Failed to install lazygit.\n"
fi

# Install arttime
printf "\n%.0s" {1..2}
printf "\n${NOTE} Install arttime...\n"
if zsh -c '{url="https://gist.githubusercontent.com/poetaman/bdc598ee607e9767fe33da50e993c650/raw/d0146d258a30daacb9aee51deca9410d106e4237/arttime_online_installer.sh"; zsh -c "$(curl -fsSL $url || wget -qO- $url)"}'; then
    printf "\n${OK} Arttime install successfully\n"
else
    printf "\n${ERROR} Failed to install arttime\n"
fi

# Install and initial neovim
cd $HOME
printf "\n%.0s" {1..2}
printf "\n${NOTE} Install neovim\n"
if sudo dpkg -l | grep -q -w nvim; then
    sudo nala remove neovim -y
fi
printf "\n%.0s" {1..2}
if curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz; then
    printf "\n${OK} Download lastest version neovim successfully\n"
else
    printf "\n${ERROR} Failed to download neovim\n"
fi
printf "\n%.0s" {1..2}
mkdir -p ~/.local/bin && mv nvim-linux64.tar.gz ~/.local/bin && cd ~/.local/bin && tar xzvf nvim-linux64.tar.gz && rm -fr nvim-linux64.tar.gz && ln -s ./nvim-linux64/bin/nvim ./nvim && printf "\n${OK} Install neovim successfully\n\n\n" || {
    printf "\n${OK} Failed to install neovim\n"
}
printf "\n%.0s" {1..2}
printf "\n${NOTE} Setup neovim\n"
if rm -rf ~/.config/nvim && rm -rf ~/.local/share/nvim && git clone https://github.com/nhattruongNeoVim/MYnvim.git ~/.config/nvim --depth 1; then
    printf "\n${OK} Setup neovim successfully\n"
else
    printf "\n${ERROR} Failed to setup neovim\n"
fi

# Clone dotfiles
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

printf "\n%.0s" {1..2}
printf "\n${NOTE} Start config\n"

folder=(
    neofetch
    ranger
    tmux
    starship.toml
)

# Back up configuration file
for DIR in "${folder[@]}"; do
    DIRPATH=~/.config/"$DIR"
    if [ -d "$DIRPATH" ]; then
        echo -e "${NOTE} - Config for $DIR found, attempting to back up."
        BACKUP_DIR=$(get_backup_dirname)
        mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR"
        echo -e "${NOTE} - Backed up $DIR to $DIRPATH-backup-$BACKUP_DIR."
    fi
done

# Copying configuration file
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
