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
write_ask "Are you dual booting Windows and Ubuntu? (y/n): "
read answer
if [ "$answer" = 'y' ]; then
    write_start "I will set the local time on Ubuntu to display the correct time on Windows."
    timedatectl set-local-rtc 1 --adjust-system-clock
fi
write_done

# Set background
write_start "Change background..."
    cd ~/dotfiles/picture
    mkdir ~/Pictures/Wallpapers
    mv background.jpg ~/Pictures/Wallpapers
write_done

# Install and init nala
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
    write_start "Press 1 2 3 and press Enter"
    sudo nala fetch
write_done

# Install packages
write_start "Installing packages..."
    sudo nala install git neofetch xclip zsh kitty cargo bat ibus-unikey default-jre default-jdk
    sudo nala install fzf make cmake pip tmux
    curl -sS https://starship.rs/install.sh | sh
    zsh -c '{url="https://gist.githubusercontent.com/poetaman/bdc598ee607e9767fe33da50e993c650/raw/8487de3cf4cf4a7feff5d3a0d97defad95164eb3/arttime_online_installer.sh"; zsh -c "$(curl -fsSL $url || wget -qO- $url)"}'
write_done

# Change shell
write_start "Change shell to zsh..."
    chsh -s /bin/zsh
write_done 

# Install grub-customizer
write_start "Install grub-customizer..."
    sudo add-apt-repository ppa:danielrichter2007/grub-customizer
    sudo nala install grub-customizer
write_done

# Install and config neovim
write_start "Install and config neovim version 0.9.2..."
    cd ~/dotfiles/config/ubuntu/nvim
    sudo nala remove nvim -y
    mkdir -p ~/.local/bin
    mv nvim-linux64.tar.gz ~/.local/bin
    cd ~/.local/bin
    tar xzvf nvim-linux64.tar.gz
    rm -fr nvim-linux64.tar.gz
    ln -s ./nvim-linux64/bin/nvim ./nvim
    nvim --version
    cd ~/dotfiles/config/ubuntu
    mv nvim ~/.config
    pip install pynvim
    sudo npm install neovim -g
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

# Install POP_OS
write_start "Install POP_OS..."
    cd ~
    git clone https://github.com/pop-os/shell.git
    cd shell
    make local-install
write_done

# Install Rust
write_start "Install Rust..."
    curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh
    cargo install lsd --locked
    cargo --version
write_done
