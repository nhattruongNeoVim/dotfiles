#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# prerequisites
sudo apt update -y
sudo apt install -y curl git unzip

# ensure computer doesn't go to sleep or lock while installing
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

# start script
exScriptHypr "pacman.sh"


# revert to normal idle and lock settings
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300

# Logout to pickup changes
gum confirm "Ready to logout for all settings to take effect?" && gnome-session-quit --logout --no-prompt
