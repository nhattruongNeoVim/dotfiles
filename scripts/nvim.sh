#!/bin/bash
# Setup Neovim

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

# Update packages
sudo apt update && sudo apt upgrade && sudo apt install nala && sudo nala update && sudo nala upgrade

# Color util
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"

dependencies=(    
    fzf 
    make 
    cmake 
    pip 
    unzip 
    gzip 
    tar 
    default-jdk 
    ripgrep 
    yarn 
    curl
    gnupg
    ca-certificates
)

install_package() {
    if sudo dpkg -l | grep -q -w "$1" ; then
        echo -e "${OK} $1 is already installed. Skipping..."
    else
        echo -e "${NOTE} Installing $1 ..."
        sudo nala install -y "$1"
        if sudo dpkg -l | grep -q -w "$1" ; then
            echo -e "\e[1A\e[K${OK} $1 was installed."
        else
            echo -e "\e[1A\e[K${ERROR} $1 failed to install :( You may need to install manually! Sorry, I have tried :("
            exit 1
        fi
    fi
}

# Install packages
for PKG1 in "${dependencies[@]}"; do
    install_package "$PKG1"
    if [ $? -ne 0 ]; then
        echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the script."
        exit 1
    fi
done

# Install NodeJS
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

pip install pynvim
sudo npm install neovim -g  
mkdir -p ~/out
