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
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

install_nala_package() {
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
)

printf "\n${NOTE} Installing nala packages...\n"
for PKG1 in "${nala_packages[@]}"; do
	install_nala_package "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the script."
		exit 1
	fi
done

printf "\n${NOTE} Install starship...\n"
if curl -sS https://starship.rs/install.sh | sh; then
	printf "\n${OK} Starship is installed successfully!\n\n\n"
fi

printf "\n${NOTE} Install arttime...\n"
if zsh -c '{url="https://gist.githubusercontent.com/poetaman/bdc598ee607e9767fe33da50e993c650/raw/8487de3cf4cf4a7feff5d3a0d97defad95164eb3/arttime_online_installer.sh"; zsh -c "$(curl -fsSL $url || wget -qO- $url)"}'; then
	printf "\n${OK} Arttime is installed successfully!\n\n\n"
fi

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

# Install pipes.sh
cd ~
if [ -d pipes.sh ]; then
	rm -rf pipes.sh
fi

if command -v pipes.sh &>/dev/null; then
	printf "\n%s - Pipes already installed, moving on.\n" "${OK}"
else
	printf "\n%s - Pipes was NOT located\n" "${NOTE}"
	printf "\n%s - Installing pipes\n" "${NOTE}"
	git clone https://github.com/pipeseroni/pipes.sh --depth 1 || {
		printf "%s - Failed to clone pipes\n" "${ERROR}"
		exit 1
	}
	cd pipes.sh || {
		printf "%s - Failed to enter pipes directory\n" "${ERROR}"
		exit 1
	}
	make PREFIX=$HOME/.local install || {
		printf "%s - Failed to install pipes.sh\n" "${ERROR}"
		exit 1
	}
	cd ~ && rm -rf pipes.sh || {
		printf "%s - Failed to remove pipes.sh directory\n" "${ERROR}"
		exit 1
	}
fi

# Install homebrew
bash <(curl -sSL "https://raw.githubusercontent.com/nhattruongNeoVim/dotfiles/master/scripts/hyprland/homebrew.sh")

# Install homebrew package
brew_package=(
	rustup
	node
	neovim
	node
)

printf "\n${NOTE} Installing brew packages...\n"
for PKG2 in "${brew_package[@]}"; do
	install_brew_package "$PKG2"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG2 install had failed, please check the script."
		exit 1
	fi
done

# Initial rust
if rustup-init && source $HOME/.cargo/env && cargo --version && cargo install lsd --locked; then
	printf "\n${OK} Initial rust is successfully!\n\n\n"
fi

# Initial neovim
printf "\n${NOTE} Setup neovim!\n"
if git clone https://github.com/nhattruongNeoVim/MYnvim.git ~/.config/nvim --depth 1; then
	printf "\n${OK} Setup neovim successfully!\n\n\n"
fi

# Config
cd ~
printf "\n${NOTE} Start config!\n"
printf "\n${NOTE} Clone dotfiles. "
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

folder=(
	neofetch
	ranger
	tmux
)

get_backup_dirname() {
	local timestamp
	timestamp=$(date +"%m%d_%H%M")
	echo "back-up_${timestamp}"
}

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
for DIR2 in "${folder[@]}"; do
	cp -r "config/$DIR2" ~/.config/ && { echo "${OK}Copy completed"; } || {
		echo "${ERROR} Failed to copy config files."
	}
done

# Copying other
cp assets/.zshrc ~ && cp assets/.ideavimrc ~ && { echo "${OK}Copy completed!"; } || {
	echo "${ERROR} Failed to copy .zshrc && .ideavimrc"
}

# copying icon
mkdir -p ~/.icons
cp -r assets/.icons/* ~/.icons/ && { echo "${OK}Copy icons completed!"; } || {
	echo "${ERROR} Failed to copy icons files."
}

# copying font
mkdir -p ~/.fonts
cp -r assets/.fonts/* ~/.fonts/ && { echo "${OK}Copy fonts completed!"; } || {
	echo "${ERROR} Failed to copy fonts files."
}

# copying theme
mkdir -p ~/.themes
cp -r assets/.themes/* ~/.themes && { echo "${OK}Copy themes completed!"; } || {
	echo "${ERROR} Failed to copy themes files."
}

# reload fonts
printf "\n%.0s" {1..2}
fc-cache -fv

# Chang shell to zsh
printf "\n${NOTE} Change shell to zsh!\n"
chsh -s $(which zsh)

printf "\n%.0s" {1..2}
printf "\n${OK} Yey! Setup Completed.\n"
printf "\n%.0s" {1..2}

nvim
zsh
