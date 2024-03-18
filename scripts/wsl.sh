#!/bin/bash
# config wsl

echo -e "\e[34m   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____ "
echo -e "  |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |"
echo -e "  |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|"
echo -e "  |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |"
echo -e "  |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |"
echo -e "  |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |"
echo -e "  |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|"
echo -e ""
echo -e ""
echo -e "-------------------- Script developed by nhattruongNeoVim --------------------"
echo -e " -------------- Github: https://github.com/nhattruongNeoVim -----------------"
echo

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
RESET=$(tput sgr0)

install_nala_package() {
	printf "\n%.0s" {1..2}
	if sudo dpkg -l | grep -q -w "$1"; then
		echo -e "${OK} $1 is already installed. Skipping..."
	else
		echo -e "${NOTE} Installing $1 ..."
		sudo nala install -y "$1"
		if sudo dpkg -l | grep -q -w "$1"; then
			echo -e "\e[1A\e[K${OK} $1 was installed."
		else
			echo -e "\e[1A\e[K${ERROR} $1 failed to install. You may need to install manually! Sorry, I have tried :("
			exit 1
		fi
	fi
}

install_brew_package() {
	printf "\n%.0s" {1..2}
	if brew list "$1" &>/dev/null; then
		echo -e "${OK} $1 is already installed. Skipping..."
	else
		echo -e "${NOTE} Installing $1 ..."
		brew install "$1"
		if brew list "$1" &>/dev/null; then
			echo -e "\e[1A\e[K${OK} $1 was installed."
		else
			echo -e "\e[1A\e[K${ERROR} $1 failed to install. You may need to install manually! Sorry, I have tried :("
			exit 1
		fi
	fi
}

get_backup_dirname() {
	local timestamp
	timestamp=$(date +"%m%d_%H%M")
	echo "back-up_${timestamp}"
}

printf "\n${NOTE} Check for update...\n"
if sudo apt update && sudo apt upgrade -y; then
	printf "\n${OK} Apt update successfully!\n\n\n"
fi

printf "\n${NOTE} Check nala...\n"
if ! command -v nala &>/dev/null; then
	echo -e "${CAT} Installing nala...${RESET}"
	sudo apt install nala -y
else
	printf "\n${OK} Nala is already installed!\n\n\n"
fi

printf "\n${CAT} Update nala...${RESET}\n"
if sudo nala update && sudo nala upgrade -y; then
	printf "\n${OK} Nala update successfully!\n\n\n"
fi

printf "\n${NOTE} Initializing Nala...\n"
printf "\n${NOTE} Press 1 2 3 and press Enter \n"
if sudo nala fetch; then
	printf "\n${OK} Initializing nala successfully!\n\n\n"
fi

nala_packages=(
	build-essential
	python3
	python3-pip
	git
	neofetch
	xclip
	zsh
	bat
	default-jdk
	htop
	fzf
	make
	ripgrep
	cmake
	tmux
	cava
	net-tools
	unzip
	lolcat
	sl
	ca-certificates
	curl
	gnupg
	ranger
)

printf "\n${NOTE} Installing nala packages...\n"
for PKG1 in "${nala_packages[@]}"; do
	install_nala_package "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the script."
		exit 1
	fi
done

# Install colorscript
cd ~
if [ -d shell-color-scripts ]; then
	rm -rf shell-color-scripts
fi

if command -v colorscript &>/dev/null; then
	printf "\n%s - Colorscript already installed, moving on.\n" "${OK}"
else
	printf "\n%s - Colorscript was NOT located\n" "${NOTE}"
	printf "\n%s - Installing colorscript\n" "${NOTE}"
	git clone https://gitlab.com/dwt1/shell-color-scripts.git --depth 1 || {
		printf "%s - Failed to clone colorscript\n" "${ERROR}"
		exit 1
	}
	cd shell-color-scripts || {
		printf "%s - Failed to enter colorscript directory\n" "${ERROR}"
		exit 1
	}
	sudo make install && sudo cp completions/_colorscript /usr/share/zsh/site-functions || {
		printf "%s - Failed to install colorscript\n" "${ERROR}"
		exit 1
	}
	cd ~ && rm -rf shell-color-scripts || {
		printf "%s - Failed to remove colorscript directory\n" "${ERROR}"
		exit 1
	}
fi

# Install homebrew
bash <(curl -sSL "https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/homebrew.sh")
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew_package=(
	rustup
	node
	lazygit
	pipes-sh
	starship
)

# Install brew packages
printf "\n${NOTE} Installing brew packages...\n"
for PKG2 in "${brew_package[@]}"; do
	install_brew_package "$PKG2"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG2 install had failed, please check the script."
		exit 1
	fi
done

# Install arttime 
printf "\n%.0s" {1..2}
printf "\n${NOTE} Install arttime...!\n"
if zsh -c '{url="https://gist.githubusercontent.com/poetaman/bdc598ee607e9767fe33da50e993c650/raw/d0146d258a30daacb9aee51deca9410d106e4237/arttime_online_installer.sh"; zsh -c "$(curl -fsSL $url || wget -qO- $url)"}'; then
	printf "\n${OK} Arttime install successfully!\n\n\n"
else
	printf "\n${ERROR} Failed to install arttime!\n\n\n"
fi

# Initial rust
if rustup-init && source $HOME/.cargo/env && cargo --version && cargo install lsd --locked; then
	printf "\n${OK} Initial rust successfully!\n\n\n"
fi

# Clone dotfiles
cd ~
if [ -d dotfiles ]; then
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles config directory\n" "${ERROR}"
		exit 1
	}
else
	printf "\n${NOTE} Clone dotfiles. " && git clone -b gnome https://github.com/nhattruongNeoVim/dotfiles.git ~/dotfiles --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd dotfiles || {
		printf "%s - Failed to enter dotfiles directory\n" "${ERROR}"
		exit 1
	}
fi

# Install and initial neovim
printf "\n${NOTE} Install neovim!\n"
if sudo dpkg -l | grep -q -w "nvim"; then
	sudo nala remove neovim -y
fi
cd assets && mkdir -p ~/.local/bin && cp nvim-linux64.tar.gz ~/.local/bin && cd ~/.local/bin && tar xzvf nvim-linux64.tar.gz && rm -fr nvim-linux64.tar.gz && ln -s ./nvim-linux64/bin/nvim ./nvim && printf "\n${OK} Initial rust successfully!\n\n\n" || {
	printf "\n${OK} Failed to install neovim!\n\n\n"
}
printf "\n${NOTE} Setup neovim!\n"
if rm -rf ~/.config/nvim && rm -rf ~/.local/share/nvim && git clone https://github.com/nhattruongNeoVim/MYnvim.git ~/.config/nvim --depth 1; then
	printf "\n${OK} Setup neovim successfully!\n\n\n"
fi

# Config
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
cp assets/.zshrc ~ && cp assets/.ideavimrc ~ && { echo "${OK}Copy completed!"; } || {
	echo "${ERROR} Failed to copy .zshrc && .ideavimrc"
}

# Copying font
mkdir -p ~/.fonts
cp -r assets/.fonts/* ~/.fonts/ && { echo "${OK}Copy fonts completed!"; } || {
	echo "${ERROR} Failed to copy fonts files."
}

# Reload fonts
printf "\n%.0s" {1..2}
fc-cache -fv

# Setup Homebrew before proceeding
printf "\n${NOTE} Set up Homebrew!\n"
(
	echo
	echo '# Auto generated by Homebrew'
	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
) >>$HOME/.zshrc || {
	printf "%s - Failed to setup Homebrew\n" "${ERROR}"
	exit 1
}

cd ~
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

nvim

zsh
