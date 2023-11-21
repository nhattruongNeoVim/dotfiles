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

write_ask() {
    echo -en "\e[32m>> $1\e[0m"
}

# Start script
# Set local time
while [[ true ]]; do
    write_ask "Are you dual booting Windows and Ubuntu? (y/n): "
    read answer
    case $answer in
        [Yy]* )
            write_start "I will set the local time on Ubuntu to display the correct time on Windows."
            timedatectl set-local-rtc 1 --adjust-system-clock
            break;;
        [Nn]* )
            break;;
        *) 
            echo -en '\e[34m Please answer yes or no !\n'
    esac
done

# Set background
# write_start "Change background..."
#     cd ~/dotfiles/picture
#     mkdir ~/Pictures/Wallpapers
#     mv background.jpg ~/Pictures/Wallpapers
# write_done
write_start "Check for update..."
    sudo apt update && sudo apt upgrade -y
write_done

# Install nala
write_start "Check nala..."
if ! command -v nala &> /dev/null
then
    write_start "Installing nala..."
    sudo apt install nala -y
else
    write_start "Nala is already installed"
fi

# Init nala
write_start "Initializing Nala..."
    sudo nala update && sudo nala upgrade -y
    write_start "Press 1 2 3 and press Enter \n"
    sudo nala fetch
write_done

# Install packages
write_start "Installing packages..."
    sudo nala install git neofetch xclip zsh kitty bat rofi ibus-unikey openjdk-19-jre-headless openjdk-19-jdk-headless htop stow -y
    sudo nala install fzf make cmake aria2 pip tmux cava net-tools python3.10-venv unzip lolcat cpufetch bpytop figlet sl cmatrix trash-cli ranger hollywood -y
    sudo add-apt-repository ppa:danielrichter2007/grub-customizer
    sudo nala update && sudo nala upgrade -y
    sudo nala install grub-customizer -y
    curl -sS https://starship.rs/install.sh | sh
    # Install arttime
    zsh -c '{url="https://gist.githubusercontent.com/poetaman/bdc598ee607e9767fe33da50e993c650/raw/8487de3cf4cf4a7feff5d3a0d97defad95164eb3/arttime_online_installer.sh"; zsh -c "$(curl -fsSL $url || wget -qO- $url)"}'
write_done

# Install pipes.sh
write_start "Install pipes.sh..."
    cd ~
    git clone https://github.com/pipeseroni/pipes.sh
    cd pipes.sh
    make PREFIX=$HOME/.local install
    cd ..
    rm -rf pipes.sh
write_done

# Install Rust
write_start "Install Rust..."
    curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh
    #bash
    source $HOME/.cargo/env
    cargo --version
    cargo install lsd --locked
write_done

# Install Nodejs
write_start "Install Nodejs..."
    sudo nala update
    sudo nala install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    NODE_MAJOR=21
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo nala update
    sudo nala install nodejs -y
    # How to uninstall:
    # apt-get purge nodejs &&\
    # rm -r /etc/apt/sources.list.d/nodesource.list &&\
    # rm -r /etc/apt/keyrings/nodesource.gpg
write_done

# Change shell
write_start "Change shell to zsh..."
    chsh -s /bin/zsh
write_done 

write_start "Start config"
write_start "Clone dotfiles..."
    git clone https://github.com/nhattruongNeoVim/dotfiles ~
    cd ~
    rm .zshrc .ideavimrc
    rm -rf .fonts .icons .themes
    cd .config
    rm -rf alacritty kitty neofetch ranger rofi tmux
    cd ~/dotfiles
    stow config home
    
    fc-cache -fv
    sudo cp ~/dotfiles/others/ANSIShadow.flf /usr/share/figlet/
    cd ~/.themes/nhattruongNeoVimTheme
    mkdir -p ~/.config/gtk-4.0
    cp -rf gtk-4.0 ~/.config
write_done
    
# Install neovim
write_start "Install and config neovim version 0.9.2..."
    cd ~/dotfiles/others
    sudo nala remove nvim -y
    mkdir -p ~/.local/bin
    cp nvim-linux64.tar.gz ~/.local/bin
    cd ~/.local/bin
    tar xzvf nvim-linux64.tar.gz
    rm -fr nvim-linux64.tar.gz
    ln -s ./nvim-linux64/bin/nvim ./nvim
    git clone git@github.com:nhattruongNeoVim/MYnvim ~/.config/nvim
write_done

# Config neovim switcher
while [[ true ]]; do
    write_ask "Are you want to config neovim switcher(use multiple nvim)? (y/n): "
    read answer1
    case $answer1 in
        [Yy]* )
            echo -e "\n"
            write_start "Use neovim with: LazyVim, NvChad, AstroNvim"
            git clone --depth 1 https://github.com/LazyVim/starter ~/.config/LazyVim
            git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/NvChad
            git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/AstroNvim
            break;;
        [Nn]* )
            break;;
        *) 
            echo -en '\e[34m Please answer yes or no !\n'
    esac
done

# Install POP_OS
#write_start "Install POP_OS..."
    #cd ~
    #sudo nala install git node-typescript make -y
    #sudo npm install -g typescript@next --force
    #git clone https://github.com/pop-os/shell.git
    #cd shell
    #make local-install
    #cd ..
    #rm -rf shell
#write_done

reboot
