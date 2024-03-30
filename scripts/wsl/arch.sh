#!/bin/bash
# config wsl

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# start script
exScriptHypr "pacman.sh"

clear
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

packages=(
	tmux
	starship
	zsh
	make
	python-pip
	nodejs
	npm
	# python-virtualenv
	ripgrep
	fzf
	neofetch
	lsd
	lazygit
	net-tools
	neovim
	bat
	neovide
	ranger
	aria2
)

# Installation of main components
printf "\n%s - Installing components\n" "${NOTE}"

for PKG1 in "${packages[@]}"; do
	install_pacman_pkg "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done

if [ "$aur_helper" == "paru" ]; then
	exScriptHypr "paru.sh"
elif [ "$aur_helper" == "yay" ]; then
	exScriptHypr "yay.sh"
fi

# Set up neovim
printf "\n%.0s" {1..2}
printf "\n${NOTE} Setup neovim!\n"
if rm -rf ~/.config/nvim && rm -rf ~/.local/share/nvim && git clone https://github.com/nhattruongNeoVim/MYnvim.git ~/.config/nvim --depth 1; then
	printf "\n${OK} Setup neovim successfully!\n"
else
	printf "\n${ERROR} Failed to setup neovim!\n"
fi

# remove dotfiles
cd $HOME
if [ -d dotfiles ]; then
	rm -rf dotfiles
	echo -e "${NOTE} Remove dotfile successfully "
fi

# Chang shell to zsh
printf "\n${NOTE} Change shell to zsh!\n"
chsh -s $(which zsh)

printf "\n%.0s" {1..2}
printf "\n${OK} Yey! Setup Completed.\n"
printf "\n%.0s" {1..2}

zsh

