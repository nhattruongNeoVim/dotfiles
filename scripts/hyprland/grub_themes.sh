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
theme="Huohuo"
grub="/etc/default/grub"
grub_theme="/boot/grub/themes/$theme/theme.txt"

# Ask user
while true; do
	read -n1 -rep "\n${NOTE}Do you want to install grub custom theme? (y/n) " answer

	if [[ $answer == "y" || $answer == "Y" ]]; then

		# Check file
		if [ ! -f "$grub" ]; then
			echo "${WARN} $grub does not exist"
			break
		fi

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

		printf "\n%.0s" {1..2}

		# Update GRUB_TIMEOUT
		sudo sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=\"-1\"/" "$grub"
		sudo sed -i "s/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=\"hidden\"/" "$grub"
		echo "${OK} Disable grub timeouts in $grub"

		# # Check and diable SUBMENU
		# if grep -q "^.*GRUB_DISABLE_SUBMENU=" "$grub"; then
		# 	sudo sed -i "s|^.*GRUB_DISABLE_SUBMENU=.*|GRUB_DISABLE_SUBMENU=y|" "$grub"
		# 	echo "${OK} Disable submenu in $grub"
		# else
		# 	echo "GRUB_DISABLE_SUBMENU=y" | sudo tee -a "$grub" >/dev/null
		# 	echo "${OK} Added GRUB_DISABLE_SUBMENU to $grub"
		# fi

		# Check and update GRUB_THEME
		if grep -q "^.*GRUB_THEME=" "$grub"; then
			sudo sed -i "s|^.*GRUB_THEME=.*|GRUB_THEME=\"$grub_theme\"|" "$grub"
			echo "${OK} Updated grub themes in $grub"
		else
			echo "GRUB_THEME=\"$grub_theme\"" | sudo tee -a "$grub" >/dev/null
			echo "${OK} Added GRUB_THEME to $grub"
		fi

		# Check and update GRUB_DISABLE_OS_PROBER
		if grep -q "^.*GRUB_DISABLE_OS_PROBER=" "$grub"; then
			sudo sed -i "s|^.*GRUB_DISABLE_OS_PROBER=.*|GRUB_DISABLE_OS_PROBER=false|" "$grub"
			echo "${OK} Updated os-prober in $grub"
		else
			echo "GRUB_DISABLE_OS_PROBER=false" | sudo tee -a "$grub" >/dev/null
			echo "${OK} Added to GRUB_DISABLE_OS_PROBER in  $grub"
		fi

		printf "\n%.0s" {1..2}

		# Extract and copy theme
		tar xzvf grub_themes/themes/"$theme".tar.gz >/dev/null
		rm -fr grub_themes/themes/"$theme".tar.gz
		sudo mkdir -p /boot/grub/themes
		sudo cp -r $theme /boot/grub/themes
		rm -rf $theme
        rm -rf grub_themes

		# Regenerate grub config
		sudo grub-mkconfig -o /boot/grub/grub.cfg

		break
	elif [[ $answer == "n" || $answer == "N" ]]; then
		break
	else
		echo "${ERROR} Invalid input. Please enter y or n."
	fi
done
