#!/bin/bash
# Setup Neovim

# Update packages
sudo apt update && sudo apt upgrade && sudo apt install nala && sudo nala update && sudo nala upgrade

# Install NodeJS
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

# Install some packages
sudo nala install fzf make cmake pip unzip gzip tar default-jdk -y
pip install pynvim
sudo npm install neovim -g  
mkdir -p ~/out
