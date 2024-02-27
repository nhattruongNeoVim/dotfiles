#!/bin/bash
# Custom firefox

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Function for installing packages
install_package_pacman() {
    local package="$1"
    if pacman -Q "$package" &>/dev/null; then
        echo -e "${OK} $package is already installed. Skipping..."
    else
        echo -e "${NOTE} Installing $package ..."
        sudo pacman -S --noconfirm "$package"
        if [ $? -eq 0 ]; then
            echo -e "${OK} $package was installed."
        else
            echo -e "${ERROR} $package failed to install. Please install it manually."
            echo "-> $package failed to install. You may need to install it manually! Sorry I have tried :(" >>~/install.log
        fi
    fi
}

# Variables
firefox_prefs=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default-*" -exec echo {}/prefs.js \;)

# Install firefox
install_package_pacman firefox

# Custom firefox
if grep -q "^.*toolkit.legacyUserProfileCustomizations.stylesheets.*" "$firefox_prefs"; then
    echo "${OK} Firefox customization already applied."
else
    echo "user_pref(\"toolkit.legacyUserProfileCustomizations.stylesheets\", true);" | sudo tee -a "$firefox_prefs" >/dev/null
    echo "${OK} Added Firefox customization."
fi

if grep -q "^.*widget.gtk.ignore-bogus-leave-notify.*" "$firefox_prefs"; then
    echo "${OK} Firefox customization already applied."
else
    echo "user_pref(\"widget.gtk.ignore-bogus-leave-notify\", 1);" | sudo tee -a "$firefox_prefs" >/dev/null
    echo "${OK} Added Firefox customization."
fi
