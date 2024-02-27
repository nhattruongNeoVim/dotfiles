#!/bin/bash
# Custom firefox

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

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

firefox_prefs=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default-*" -exec echo {}/prefs.js \;)
firefox_profile=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default-*" -exec echo {}/ \;)

install_package_pacman firefox

if grep -q "^.*toolkit.legacyUserProfileCustomizations.stylesheets.*" "$firefox_prefs"; then
	sudo sed -i "s|^.*toolkit.legacyUserProfileCustomizations.stylesheets.*|user_pref(\"toolkit.legacyUserProfileCustomizations.stylesheets\", true);|" "$firefox_prefs"
	echo "${OK} Firefox customization already applied."
else
	echo "user_pref(\"toolkit.legacyUserProfileCustomizations.stylesheets\", true);" | sudo tee -a "$firefox_prefs" >/dev/null
	echo "${OK} Added Firefox customization."
fi

if grep -q "^.*widget.gtk.ignore-bogus-leave-notify.*" "$firefox_prefs"; then
	sudo sed -i "s|^.*widget.gtk.ignore-bogus-leave-notify.*|user_pref(\"widget.gtk.ignore-bogus-leave-notify\", 1);|" "$firefox_prefs"
	echo "${OK} Firefox customization already applied."
else
	echo "user_pref(\"widget.gtk.ignore-bogus-leave-notify\", 1);" | sudo tee -a "$firefox_prefs" >/dev/null
	echo "${OK} Added Firefox customization."
fi

cd ~
if [ -d dotfiles ]; then
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles config directory\n" "${ERROR}"
		exit 1
	}
else
	printf "\n${NOTE} Clone dotfiles. " && git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git ~/dotfiles --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
		exit 1
	}
fi

if cp -r assets/chrome $firefox_profile; then
	echo "${OK} Copy chrome files successfully."
fi
