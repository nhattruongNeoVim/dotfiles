#!/bin/bash
# config wsl

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# start script
exScriptHypr "base.sh"

gum style \
	--foreground 213 --border-foreground 213 --border rounded \
	--align center --width 90 --margin "1 2" --padding "2 4" \
	"  ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____  " \
	" |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    | " \
	" |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __| " \
	" |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  | " \
	" |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ | " \
	" |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     | " \
	" |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_| " \
	"                                                                              " \
	" ------------------- Script developed by nhattruongNeoVim ------------------- " \
	"                                                                              " \
	"  -------------- Github: https://github.com/nhattruongNeoVim ---------------  " \
	"                                                                              "
printf "\n"
ask_custom_option "Choose your AUR helper" "yay" "paru" aur_helper
printf "\n"
ask_yes_no "Install zsh, color scripts (Optional) & zsh plugin (Optional)?" zsh

if [ "$aur_helper" == "paru" ]; then
	exScriptHypr "paru.sh"
elif [ "$aur_helper" == "yay" ]; then
	exScriptHypr "yay.sh"
fi

pacman_packages=(
	git
	unzip
	tmux
	starship
	zsh
	make
	python-pip
	nodejs
	npm
	ripgrep
	fzf
	neofetch
	lsd
	lazygit
	net-tools
	neovim
	bat
	ranger
	aria2
	btop
	curl
	wget
	nvtop
	cargo
	openssh
	lolcat
	python-virtualenv
)

aur_packages=(
	arttime-git
	pipes.sh
	cava
)

# reload AUR
ISAUR=$(command -v yay || command -v paru)

# Installation of main components
printf "\n%s - Installing components\n" "${NOTE}"

for PKG1 in "${pacman_packages[@]}"; do
	install_pacman_pkg "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done

for PKG2 in "${aur_packages[@]}"; do
	install_aur_pkg "$PKG2"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG2 install had failed"
	fi
done

# Set up neovim
printf "\n%.0s" {1..2}
printf "\n${NOTE} Setup neovim!\n"
if rm -rf ~/.config/nvim && rm -rf ~/.local/share/nvim && git clone https://github.com/nhattruongNeoVim/MYnvim.git ~/.config/nvim --depth 1; then
	printf "\n${OK} Setup neovim successfully!\n"
else
	printf "\n${ERROR} Failed to setup neovim!\n"
fi

# Check if dotfiles exist
cd $HOME || exit 1
if [ -d dotfiles ]; then
	rm -rf dotfiles
	echo -e "${OK} Remove dotfile successfully "
fi

# Clone dotfiles
printf "\n${NOTE} Clone dotfiles. "
if git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles.git --depth 1 && cd dotfiles; then
	printf "\n${OK} Clone dotfiles succesfully.\n"
fi

printf "\n%.0s" {1..2}
printf "\n${NOTE} Start config!\n"

folder=(
	neofetch
	ranger
	tmux
	starship.toml
)

# Back up configuration file
for DIR in "${folder[@]}"; do
	DIRPATH=~/.config/"$DIR"
	if [ -d "$DIRPATH" ]; then
		echo -e "${NOTE} - Config for $DIR found, attempting to back up."
		BACKUP_DIR=$(get_backup_dirname)
		mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR"
		echo -e "${NOTE} - Backed up $DIR to $DIRPATH-backup-$BACKUP_DIR."
	fi
done

# Copying configuration file
for ITEM in "${folder[@]}"; do
	if [[ -d "config/$ITEM" ]]; then
		cp -r "config/$ITEM" ~/.config/ && echo "${OK} Copy completed" || echo "${ERROR} Failed to copy config files."
	elif [[ -f "config/$ITEM" ]]; then
		cp "config/$ITEM" ~/.config/ && echo "${OK} Copy completed" || echo "${ERROR} Failed to copy config files."
	fi
done

# Copying other
cp assets/.zshrc ~ && { echo "${OK} Copy completed!"; } || {
	echo "${ERROR} Failed to copy .zshrc"
}

# Copying font
mkdir -p ~/.fonts
cp -r assets/.fonts/* ~/.fonts/ && { echo "${OK} Copy fonts completed!"; } || {
	echo "${ERROR} Failed to copy fonts files."
}

# Clone tpm
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
	echo "${NOTE} TPM (Tmux Plugin Manager) is already installed."
else
	# Clone TPM repository
	echo "${NOTE} Cloning TPM (Tmux Plugin Manager)..."
	if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth 1; then
		echo "${OK} TPM (Tmux Plugin Manager) cloned successfully!"
	else
		echo "${ERROR} Failed to clone TPM (Tmux Plugin Manager)."
	fi
fi

# zsh
if [ "$zsh" == "Y" ]; then
	exScriptHypr "zsh.sh"
fi

# remove dotfiles
cd $HOME
if [ -d dotfiles ]; then
	rm -rf dotfiles
	echo -e "${NOTE} Remove dotfile successfully "
fi

# clear packages
printf "\n${NOTE} Clear packages.\n"
if sudo pacman -Sc --noconfirm && yay -Sc --noconfirm && yay -Yc --noconfirm; then
	printf "\n${OK} Clear packages succesfully.\n"
fi

printf "\n%.0s" {1..2}
printf "\n${OK} Yey! Setup Completed.\n"
printf "\n%.0s" {1..2}

zsh
