#!/bin/bash
# zsh

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# star scripts
clear
gum style \
	--foreground 213 --border-foreground 213 --border rounded \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	"███████╗███████╗██╗  ██╗" \
	"╚══███╔╝██╔════╝██║  ██║" \
	"  ███╔╝ ███████╗███████║" \
	" ███╔╝  ╚════██║██╔══██║" \
	"███████╗███████║██║  ██║" \
	"╚══════╝╚══════╝╚═╝  ╚═╝"

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
	starship
)

# optional color scripts
printf "\n"
if gum confirm "${CAT} - Do you want to add color scripts (OPTIONAL)?"; then
	echo "${CAT} - Do you want to add color scripts (OPTIONAL)?" $YELLOW Yes
	if gum confirm "$YELLOW Choose your colors cripts" --affirmative "pokemon-colorscripts" --negative "shell-color-scripts"; then
		zsh+=('pokemon-colorscripts-git')
		sed -i '/^# pokemon-colorscripts --no-title -s -r/s/^# *//' assets/.zshrc
	else
		zsh+=('shell-color-scripts')
		sed -i '/^# colorscript -e tiefighter2/ s/^# //' assets/.zshrc
	fi
else
	echo "${CAT} - Do you want to add command prompt (OPTIONAL)?" $YELLOW No
	echo "${NOTE} Skipping Pokemon color scripts installation.${RESET}"
fi

# optional zsh plugin
printf "\n"
if gum confirm "${CAT} - Do you want to add zsh plugin (OPTIONAL)?"; then
    echo "${CAT} - Do you want to add zsh plugin (OPTIONAL)?" $YELLOW Yes
	echo "$ORANGE SPACE = select/unselect | j/k = down/up | ENTER = confirm. No selection = CANCEL"
	plugin=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "zsh-completions" "zsh-syntax-highlighting")

	if [ -z "${plugin}" ]; then
		echo "No profile selected. Installation canceled."
		exit
	else
		echo "\t $YELLOW Plugin selected: " $plugin
	fi

	if [[ $plugin == *"zsh-completions"* ]]; then
		zsh+=('zsh-completions')
		sed -i '/^# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh/s/^# *//' assets/.zshrc
	fi
	if [[ $plugin == *"zsh-syntax-highlighting"* ]]; then
		zsh+=('zsh-syntax-highlighting')
		sed -i '/^# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh/s/^# *//' assets/.zshrc
	fi
fi

# installing zsh packages
printf "\n"
printf "${NOTE} Installing core zsh packages...${RESET}\n"
for ZSH in "${zsh[@]}"; do
	install_pacman_pkg "$ZSH"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $ZSH install had failed"
	fi
done

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
