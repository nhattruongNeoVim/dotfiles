#!/bin/bash
# install packages

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

PIPES="https://github.com/pipeseroni/pipes.sh"
COLORSCRIPT="https://gitlab.com/dwt1/shell-color-scripts.git"
NODEJS="https://deb.nodesource.com/setup_22.x"
ARTTIME="https://github.com/poetaman/arttime/releases/download/v2.3.4/arttime_2.3.4-1_all.deb"
NEOVIM="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
LAZYGIT="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

pkgs=(
    build-essential
    neofetch
    xclip
    zsh
    kitty
    bat
    rofi
    ibus-unikey
    python3
    python3-pip
    python3.11-venv
    python3-neovim
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
    lolcat
    cpufetch
    bpytop
    figlet
    sl
    cmatrix
    trash-cli
    ranger
    hollywood
    grub-customizer
    ca-certificates
    gnupg
)

printf "\n%s - Install packages .... \n" "${NOTE}"
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
