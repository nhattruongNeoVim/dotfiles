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

# variable
PIPES="https://github.com/pipeseroni/pipes.sh"
COLORSCRIPT="https://gitlab.com/dwt1/shell-color-scripts.git"
NODEJS="https://deb.nodesource.com/setup_22.x"
ARTTIME="https://github.com/poetaman/arttime/releases/download/v2.3.4/arttime_2.3.4-1_all.deb"
NEOVIM="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
LAZYGIT="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

# reload package manager
PKGMN=$(command -v nala || command -v apt)

# add repository
printf "\n%s - Add repository .... \n" "${NOTE}"
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch

# reupdate system
printf "\n%s - Update system .... \n" "${NOTE}"
if sudo $PKGMN update && sudo $PKGMN upgrade -y; then
    printf "\n%s - Update system successfully \n" "${OK}"
else
    printf "\n%s - Failed to update your system \n" "${ERROR}"
fi

# list packages
pkgs=(
    fastfetch
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
printf "\n%s - Install packages .... \n" "${NOTE}"
for PKG in "${pkgs[@]}"; do
    install_ubuntu_packages "$PKG"
    if [ $? -ne 0 ]; then
        printf "\n%s - $PKG install had failed, please check the script. \n" "${ERROR}"
    fi
done

# install Nodejs
if command -v node &>/dev/null; then
    printf "\n%s - Node already installed, moving on \n" "${OK}"
else
    printf "\n%s - Download Node.js setup script .... \n" "${NOTE}"
    if curl -fsSL "$NODEJS" -o nodesource_setup.sh; then
        printf "\n%s - Download the Node.js setup script successfully \n" "${OK}"
        printf "\n%s - Install Node.js .... \n" "${NOTE}"
        if sudo -E bash nodesource_setup.sh && sudo $PKGMN install -y nodejs; then
            rm nodesource_setup.sh
            printf "\n%s - Install Node.js successfully \n" "${OK}"
        else
            printf "\n%s - Install Node.js had failed \n" "${ERROR}"
        fi
    else
        printf "\n%s - Download the Node.js setup script had failed \n" "${ERROR}"
    fi
fi

# install Rust
if command -v rustc &>/dev/null; then
    printf "\n%s - Rust already installed, moving on \n" "${OK}"
else
    printf "\n%s - Install Rust ... \n" "${NOTE}"
    if curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh; then
        printf "\n%s - Rust was installed \n" "${OK}"
        source $HOME/.cargo/env
    else
        printf "\n%s - Rust install had failed \n" "${ERROR}"
    fi
fi

# install Lsd
if command -v lsd &>/dev/null; then
    printf "\n%s - Lsd already installed, moving on \n" "${OK}"
else
    printf "\n%s - Install lsd ... \n" "${NOTE}"
    if cargo install lsd --locked; then
        printf "\n%s - Lsd was installed \n" "${OK}"
    else
        printf "\n%s - Lsd install had failed \n" "${ERROR}"
    fi
fi

# install Starship
if command -v starship &>/dev/null; then
    printf "\n%s - Starship already installed, moving on \n" "${OK}"
else
    printf "\n%s - Install starship ... \n" "${NOTE}"
    if cargo install starship --locked; then
        printf "\n%s - Starship was installed \n" "${OK}"
    else
        printf "\n%s - Starship install had failed \n" "${ERROR}"
    fi
fi

# install Arttime
if command -v arttime &>/dev/null; then
    printf "\n%s - Arttime already installed, moving on \n" "${OK}"
else
    printf "\n%s - Download arttime.deb .... \n" "${NOTE}"
    if wget -O /tmp/arttime.deb "$ARTTIME"; then
        printf "\n%s - Download arttime.deb successfully.... \n" "${OK}"
        printf "\n%s - Install arttime .... \n" "${NOTE}"
        if sudo $PKGMN install -y /tmp/arttime.deb; then
            printf "\n%s - Install arttime successfully \n" "${OK}"
        else
            printf "\n%s - Arttime install had failed \n" "${ERROR}"
        fi
    else
        printf "\n%s - Failed to download arttime.deb \n" "${ERROR}"
    fi
fi

# install Colorscript
if command -v colorscript &>/dev/null; then
    printf "\n%s - Colorscript already installed, moving on \n" "${OK}"
else
    printf "\n%s - Clone colorscript .... \n" "${NOTE}"
    if git clone "$COLORSCRIPT" /tmp/colorscript; then
        printf "\n%s - Clone shell-color-scripts successfully \n" "${OK}"
        printf "\n%s - Install colorscript .... \n" "${NOTE}"
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

# install Pipes
if command -v pipes.sh &>/dev/null; then
    printf "\n%s - Pipes.sh already installed, moving on.\n" "${OK}"
else
    printf "\n%s - Clone pipes.sh ... \n" "${NOTE}"
    if git clone "$PIPES" /tmp/pipes.sh; then
        printf "\n%s - Clone pipe.sh successfully \n" "${OK}"
        printf "\n%s - Install pipes.sh ... \n" "${NOTE}"
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

# install Lazygit
if command -v lazygit &>/dev/null; then
    printf "\n%s - Lazygit already installed, moving on.\n" "${OK}"
else
    printf "\n%s - Download lazygit ... \n" "${NOTE}"
    if wget -O /tmp/lazygit.tar.gz "$LAZYGIT" && tar -xf /tmp/lazygit.tar.gz -C /tmp; then
        printf "\n%s - Download lazygit.tar successfully \n" "${OK}"
        printf "\n%s - Install lazygit ... \n" "${NOTE}"
        if sudo install /tmp/lazygit /usr/local/bin; then
            printf "\n%s - Install lazygit successfully \n" "${OK}"
        else
            printf "\n%s - Failed to install lazygit \n" "${ERROR}"
        fi
    else
        printf "\n%s - Failed to download lazygit \n" "${ERROR}"
    fi
fi

# install Neovim
if command -v nvim &>/dev/null; then
    printf "\n%s - Remove old version of neovim ... \n" "${NOTE}"
    sudo $PKGMN remove neovim -y
fi
printf "\n%s - Download lastest version of neovim ... \n" "${NOTE}"
if wget -O /tmp/nvim-linux64.tar.gz "$NEOVIM"; then
    printf "\n%s - Download lastest version of neovim successfully \n" "${OK}"
    printf "\n%s - Install neovim ... \n" "${NOTE}"
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

# config MYnvim
printf "\n%s - Setup MYnvim ... \n" "${NOTE}"
[ -d "$HOME/.config/nvim" ] && mv $HOME/.config/nvim $HOME/.config/nvim.bak &&
    printf "\n%s - Backup nvim folder successfully \n" "${OK}"
[ -d "$HOME/.local/share/nvim" ] && mv $HOME/.local/share/nvim $HOME/.local/share/nvim.bak &&
    printf "\n%s - Failed to backup nvim-data folder \n" "${OK}"
if git clone https://github.com/nhattruongNeoVim/MYnvim.git $HOME/.config/nvim --depth 1; then
    sudo npm install neovim -g
    printf "\n%s - Setup MYnvim successfully \n" "${OK}"
else
    printf "\n%s - Failed to setup MYnvim \n" "${ERROR}"
fi

# clone dotfiles
printf "\n%s - Clone dotfiles ... \n" "${NOTE}"
[[ -d /tmp/dotfiles ]] && rm -rf /tmp/dotfiles
git clone -b gnome https://github.com/nhattruongNeoVim/dotfiles.git /tmp/dotfiles --depth 1 || {
    printf "\n%s - Failed to clone dotfiles \n" "${ERROR}"
    exit 1
}
cd /tmp/dotfiles || {
    printf "\n%s - Failed to enter dotfiles directory \n" "${ERROR}"
    exit 1
}

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
        printf "\n%s - Config for $DIR found, attempting to back up. \n" "${NOTE}"
        BACKUP_DIR=$(get_backup_dirname)
        mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR"
        printf "\n%s - Backed up $DIR to $DIRPATH-backup-$BACKUP_DIR. \n" "${NOTE}"
    fi
done

# copying configuration file
for ITEM in "${folder[@]}"; do
    if [[ -d "config/$ITEM" ]]; then
        cp -r "config/$ITEM" ~/.config
        echo "${OK} Copy completed" || echo "${ERROR} Failed to copy config files."
    elif [[ -f "config/$ITEM" ]]; then
        cp "config/$ITEM" ~/.config
        echo "${OK} Copy completed" || echo "${ERROR} Failed to copy config files."
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

# check log
if [ -f $HOME/install.log ]; then
    if gum confirm "${CAT} - Do you want to check log?"; then
        if pacman -Q bat &>/dev/null; then
            cat_command="bat"
        else
            cat_command="cat"
        fi
        $cat_command $HOME/install.log
    fi
fi

# Chang shell to zsh
printf "\n%s - Change shell to zsh \n" "${NOTE}"
chsh -s $(which zsh) && cd $HOME

printf "\n%.0s" {1..2}
printf "\n%s - Yey! Setup Completed \n" "${OK}"
printf "\n%.0s" {1..2}

zsh
