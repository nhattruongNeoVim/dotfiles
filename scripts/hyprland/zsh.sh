#!/bin/bash
# zsh

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# check dotfiles
cd "$HOME" || exit 1
if [ -d dotfiles ]; then
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles config directory\n" "${ERROR}"
		exit 1
	}
else
	printf "\n${NOTE} Clone dotfiles. " && git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
		exit 1
	}
fi

# start
zsh=(
	zsh
	zsh-completions
)

# optional color scripts
printf "\n"
if gum confirm "${CAT} - Do you want to add color scripts (OPTIONAL)?"; then
	echo "${CAT} - Do you want to add color scripts (OPTIONAL)?" $YELLOW Yes
	if gum confirm "$YELLOW Choose your colors cripts" --affirmative "pokemon-colorscripts" --negative "shell-color-scripts"; then
		zsh+=('pokemon-colorscripts-git')
		sed -i '/# pokemon-colorscripts --no-title -s -r/s/^# *//' assets/.zshrc
	else
		zsh+=('shell-color-scripts')
		sed -i '/# colorscript -e tiefighter2 -s -r/s/^# *//' assets/.zshrc
	fi
else
	echo "${CAT} - Do you want to add command prompt (OPTIONAL)?" $YELLOW No
	echo "${NOTE} Skipping Pokemon color scripts installation.${RESET}"
fi

# optional command prompt
printf "\n"
if gum confirm "${CAT} - Do you want to add command prompt (OPTIONAL)?"; then
	echo "${CAT} - Do you want to add command prompt (OPTIONAL)?" $YELLOW Yes
	if gum confirm "$YELLOW Choose your command prompt" --affirmative "oh-my-zsh" --negative "starship"; then
		if command -v zsh >/dev/null; then
			printf "${NOTE} Installing Oh My Zsh and plugins...\n"
			if [ ! -d "$HOME/.oh-my-zsh" ]; then
				sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
			else
				echo "Directory .oh-my-zsh already exists. Skipping re-installation."
			fi

			if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
				git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions --depth 1 || true
			else
				echo "Directory zsh-autosuggestions already exists. Skipping cloning."
			fi

			if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
				git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting --depth 1 || true
			else
				echo "Directory zsh-syntax-highlighting already exists. Skipping cloning."
			fi

			sed -i '/^# export ZSH="$HOME\/.oh-my-zsh"/ s/^# //' assets/.zshrc
			sed -i '/^# ZSH_THEME="random"/ s/^# //' assets/.zshrc
			sed -i '/^# plugins=(/,/^# )/ s/^# //' assets/.zshrc
			sed -i '/^# source $ZSH\/oh-my-zsh.sh/ s/^# //' assets/.zshrc
		else
			install_pacman_pkg "starship"
			sed -i '/# eval "$(starship init zsh)" -s -r/s/^# *//' assets/.zshrc
		fi
	fi
else
	echo "${CAT} - Do you want to add command prompt (OPTIONAL)?" $YELLOW No
	echo "${NOTE} Skipping Pokemon color scripts installation.${RESET}"
fi

# installing zsh packages
printf "${NOTE} Installing core zsh packages...${RESET}\n"
for ZSH in "${zsh[@]}"; do
	install_aur_pkg "$ZSH"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $ZSH install had failed"
	fi
done

# check if ~/.zshrc and .zprofile exists, create a backup, and copy the new configuration
if [ -f "$HOME/.zshrc" ]; then
	cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup" || true
fi

if [ -f "$HOME/.zprofile" ]; then
	cp -b "$HOME/.zprofile" "$HOME/.zprofile-backup" || true
fi

# copying the preconfigured zsh themes and profile
cp assets/.zshrc $HOME && cp assets/.zprofile $HOME && { echo "${OK} Copy completed!"; } || {
	echo "${ERROR} Failed to copy .zshrc"
}

printf "${NOTE} Changing default shell to zsh...\n"

while ! chsh -s /bin/zsh; do
	echo "${ERROR} Authentication failed. Please enter the correct password."
	sleep 1
done

printf "${NOTE} Shell changed successfully to zsh.\n"
