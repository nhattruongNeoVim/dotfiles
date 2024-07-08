#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# start script
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
echo -e ""

# Function util
write_start() {
	echo -e "\e[32m $1\e[0m"
}

write_done() {
	echo -e "\e[34mDone\e[0m"
}

write_ask() {
	echo -en "\e[32m $1\e[0m"
}

# Color util
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"

# Start script
# Set local time
while [[ true ]]; do
	write_ask "Are you dual booting Windows and Ubuntu? (y/n): "
	read answer
	case $answer in
	[Yy]*)
		write_start "I will set the local time on Ubuntu to display the correct time on Windows."
		timedatectl set-local-rtc 1 --adjust-system-clock
		write_start "Add grub-customizer repository."
		sudo add-apt-repository ppa:danielrichter2007/grub-customizer
		break
		;;
	[Nn]*)
		break
		;;
	*)
		echo -en '\e[34m Please answer yes or no !\n'
		;;
	esac
done

write_start "Check for update..."
sudo apt update && sudo apt upgrade -y
write_done

# Install nala
write_start "Check nala..."
if ! command -v nala &>/dev/null; then
	write_start "Installing nala..."
	sudo apt install nala -y
else
	write_start "Nala is already installed"
fi

# Init nala
write_start "Initializing Nala..."
sudo nala update && sudo nala upgrade -y
write_start "Press 1 2 3 and press Enter \n"
sudo nala fetch
write_done

# Packages
dependencies=(
	git
	neofetch
	xclip
	zsh
	kitty
	bat
	rofi
	ibus-unikey
	default-jdk
	htop
	stow
	fzf
	make
	ripgrep
	cmake
	aria2
	pip
	tmux
	libsecret-tools
	cava
	net-tools
	unzip
	lolcat
	cpufetch
	bpytop
	figlet
	sl
	cmatrix
	trash-cli
	ranger
	hollywood
	python3.11-venv
	grub-customizer
    python3-neovim
)


# Install packages
write_start "Installing packages..."
for PKG1 in "${dependencies[@]}"; do
	install_nala_package "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "${ERROR} - $PKG1 install had failed, please check the script."
		exit 1
	fi
done

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install arttime
zsh -c '{url="https://gist.githubusercontent.com/poetaman/bdc598ee607e9767fe33da50e993c650/raw/8487de3cf4cf4a7feff5d3a0d97defad95164eb3/arttime_online_installer.sh"; zsh -c "$(curl -fsSL $url || wget -qO- $url)"}'

# Install colorscript
cd ~
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd ~/shell-color-scripts
sudo make install
# optional for zsh completion
sudo cp completions/_colorscript /usr/share/zsh/site-functions
# Removal: sudo make uninstall
cd ~
rm -rf shell-color-scripts
write_done

# Install pipes.sh
write_start "Install pipes.sh..."
cd ~
git clone https://github.com/pipeseroni/pipes.sh
cd pipes.sh
make PREFIX=$HOME/.local install
cd ..
rm -rf pipes.sh
write_done

# Install Rust
write_start "Install Rust..."
curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh
#bash
source $HOME/.cargo/env
cargo --version
cargo install lsd --locked
write_done

# Install Nodejs
write_start "Install Nodejs..."
sudo nala update
sudo nala install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=21
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo nala update
sudo nala install nodejs -y
# How to uninstall:
# apt-get purge nodejs &&\
# rm -r /etc/apt/sources.list.d/nodesource.list &&\
# rm -r /etc/apt/keyrings/nodesource.gpg
write_done

# Change shell
write_start "Change shell to zsh..."
chsh -s /bin/zsh
write_done

# Install and initial neovim
cd $HOME
printf "\n%.0s" {1..2}
printf "\n${NOTE} Install neovim!\n"
if sudo dpkg -l | grep -q -w nvim; then
	sudo nala remove neovim -y
fi
printf "\n%.0s" {1..2}
if curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz; then
	printf "\n${OK} Download lastest version neovim successfully!\n"
else
	printf "\n${ERROR} Failed to download neovim!\n"
fi
printf "\n%.0s" {1..2}
mkdir -p ~/.local/bin && mv nvim-linux64.tar.gz ~/.local/bin && cd ~/.local/bin && tar xzvf nvim-linux64.tar.gz && rm -fr nvim-linux64.tar.gz && ln -s ./nvim-linux64/bin/nvim ./nvim && printf "\n${OK} Install neovim successfully!\n\n\n" || {
	printf "\n${OK} Failed to install neovim!\n"
}
printf "\n%.0s" {1..2}
printf "\n${NOTE} Setup neovim!\n"
if rm -rf ~/.config/nvim && rm -rf ~/.local/share/nvim && git clone https://github.com/nhattruongNeoVim/MYnvim.git ~/.config/nvim --depth 1; then
	printf "\n${OK} Setup neovim successfully!\n"
else
	printf "\n${ERROR} Failed to setup neovim!\n"
fi

# Config neovim switcher
while [[ true ]]; do
	write_ask "Are you want to config neovim switcher(use multiple nvim)? (y/n): "
	read answer1
	case $answer1 in
	[Yy]*)
		echo -e "\n"
		write_start "Use neovim with: LazyVim, NvChad, AstroNvim"
		git clone --depth 1 https://github.com/LazyVim/starter ~/.config/LazyVim
		git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/NvChad
		git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/AstroNvim
		break
		;;
	[Nn]*)
		break
		;;
	*)
		echo -en '\e[34m Please answer yes or no !\n'
		;;
	esac
done

# Install POP_OS
#write_start "Install POP_OS..."
#cd ~
#sudo nala install git node-typescript make -y
#sudo npm install -g typescript@next --force
#git clone https://github.com/pop-os/shell.git
#cd shell
#make local-install
#cd ..
#rm -rf shell
#write_done

# Copy dotfiles
write_start "Start config"
write_start "Clone dotfiles..."
git clone -b gnome https://github.com/nhattruongNeoVim/dotfiles --depth 1
rm ~/.zshrc ~/.ideavimrc
rm -rf ~/.fonts ~/.icons ~/.themes
rm -rf ~/.config/alacritty ~/.config/kitty ~/.config/neofetch ~/.config/ranger ~/.config/rofi ~/.config/tmux
cd ~/dotfiles
cp -r config/* ~/.config/ && { echo "${OK}Copy completed!"; } || {
	echo "${ERROR} Failed to copy config files."
}
cp -r assets/* ~/ && { echo "${OK}Copy completed!"; } || {
	echo "${ERROR} Failed to copy config files."
}
fc-cache -fv
cd ~/.themes/Catppuccin-Mocha-Standard-Mauve-Dark
mkdir -p ~/.config/gtk-4.0
cp -rf gtk-4.0 ~/.config
write_done

# Set battery change limit
write_ask "Do you want to set battery change limit? (y/n): "
read -p "" answer2

if [ "$answer2" == "y" ] || [ "$answer2" == "Y" ]; then
	write_ask "Enter a number of battery you want to set: "
	read -p "" number

	if [[ $number =~ ^[0-9]+$ ]]; then
		if [ -d "/sys/class/power_supply/BAT1" ]; then
			write_start "Configuring crontab for BAT1..."
			echo "@reboot root echo $number > /sys/class/power_supply/BAT1/charge_control_end_threshold" | sudo tee -a /etc/crontab
			write_done
		elif [ -d "/sys/class/power_supply/BAT0" ]; then
			write_start "Configuring crontab for BAT0..."
			echo "@reboot root echo $number > /sys/class/power_supply/BAT0/charge_control_end_threshold" | sudo tee -a /etc/crontab
			write_done
		else
			write_start "BAT not found."
		fi
	else
		write_start "Invalid input. Please enter a valid number."
	fi
else
	write_start "Crontab configuration canceled."
fi

# Set up starship
printf "\n%s - Set up Starship.... \n" "${NOTE}"
(
	echo
	echo '# Auto generated by Starship'
	echo 'eval "$(starship init zsh)"'
) >>$HOME/.zshrc || {
	printf "%s - Failed to setup Starship\n" "${ERROR}"
	exit 1
}

# Reboot
for i in {10..1}; do
	write_start $i
	sleep 1
done

echo "Rebooting..."
sudo reboot
