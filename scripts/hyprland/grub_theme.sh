#!/bin/bash
# Custom grub #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Check dotfiles
cd ~
if [ -d dotfiles ]; then
	cd dotfiles || {
		printf "%s - Failed to cd dotfiles directory\n" "${ERROR}"
		exit 1
	}
else
	git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git ~/dotfiles --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
		exit 1
	}
fi

theme="BlackSwan"
grub="/etc/default/grub"
grub_theme="/boot/grub/themes/'$theme'/theme.txt"

while true; do
	read -n1 -rep "${NOTE}Do you want to install grub custom theme? (y/n) " answer

	if [[ $answer == "y" || $answer == "Y" ]]; then

		if [ -f "$grub" ]; then
			if grep -q "^GRUB_THEME=" "$grub"; then
				sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$grub_theme\"|" "$grub"
				echo "${OK} Updated GRUB_THEME in $grub"
			else
				# If GRUB_THEME doesn't exist, add it to grub file
				echo "GRUB_THEME=\"$grub_theme\"" | sudo tee -a "$grub" >/dev/null
				echo "${OK} Added GRUB_THEME to $grub"
			fi
		else
			echo "${WARN} $grub does not exist"
			break
		fi

        tar xzvf "$theme".tar.gz
        rm -fr "$theme".tar.gz

        sudo mkdir -p /boot/grub/themes
        sudo cp -r assets/$theme /boot/grub/themes

        sudo grub-mkconfig -o /boot/grub/grub.cfg

		break
	elif [[ $answer == "n" || $answer == "N" ]]; then
		break
	else
		echo "${ERROR} Invalid input. Please enter y or n."
	fi
done
