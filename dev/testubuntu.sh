#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

output_mess() {
	ak=$(gum style \
		--foreground 213 --border-foreground 213 --border rounded \
		--align center --margin "0 0" --padding "0 0" \
        "$1")
	al=$(gum style \
		--foreground 213 --border-foreground 213 --border rounded \
		--align center  --margin "0 0" --padding "0 0" \
        "$2")
    gum join --horizontal "$ak" "$al"
}

install_nala_package() {
	printf "\n%.0s" {1..2}
	if sudo dpkg -l | grep -q -w "$1"; then
        output_mess "${OK}" "$1 is already installed. Skipping..."
	else
        output_mess "${NOTE}" "Installing $1 ..."
		sudo nala install -y "$1"
		if sudo dpkg -l | grep -q -w "$1"; then
            output_mess "${OK}" "$1 was installed."
		else
            output_mess "${ERROR}" "$1 failed to install. You may need to install manually! Sorry, I have tried."
		fi
	fi
}

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
	dotnet-sdk-8.0
	fzf
	make
	ripgrep
	cmake
	tmux
	cava
	net-tools
	lolcat
	sl
	ca-certificates
	curl
	gnupg
	ranger
    btop
    btop2
    cmatrix
)

printf "\n%.0s" {1..2}
printf "\n${NOTE} Installing nala packages...\n"
for PKG1 in "${nala_packages[@]}"; do
	install_nala_package "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the script."
		exit 1
	fi
done
