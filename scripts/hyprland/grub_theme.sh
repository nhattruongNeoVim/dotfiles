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

# Variables
theme="BlackSwan"
grub="/etc/default/grub"
grub_theme="/boot/grub/themes/$theme/theme.txt"

# Ask user
while true; do
	read -n1 -rep "${NOTE}Do you want to install grub custom theme? (y/n) " answer

	if [[ $answer == "y" || $answer == "Y" ]]; then

		# Check grub themes file
        cd ~
		if [ -d grub_themes ]; then
			rm -rf grub_themes || {
				printf "%s - Failed to remove old grub themes folder\n" "${ERROR}"
				exit 1
			}
			printf "\n${NOTE} Clone grub_themes. " && git clone https://github.com/nhattruongNeoVim/grub_themes.git --depth 1 || {
				printf "%s - Failed to cd grub_themes directory\n" "${ERROR}"
				exit 1
			}
		else
			printf "\n${NOTE} Clone grub_themes. " && git clone https://github.com/nhattruongNeoVim/grub_themes.git --depth 1 || {
				printf "%s - Failed to clone grub_themes\n" "${ERROR}"
				exit 1
			}
		fi

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

		tar xzvf grub_themes/themes/"$theme".tar.gz
		rm -fr grub_themes/themes/"$theme".tar.gz

		sudo mkdir -p /boot/grub/themes
		sudo cp -r $theme /boot/grub/themes

		sudo grub-mkconfig -o /boot/grub/grub.cfg

		break
	elif [[ $answer == "n" || $answer == "N" ]]; then
		break
	else
		echo "${ERROR} Invalid input. Please enter y or n."
	fi
done
