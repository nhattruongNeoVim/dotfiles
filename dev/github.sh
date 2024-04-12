#!/bin/sh

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# start script
clear

# check if dotfiles directory exists
cd "$HOME" || exit 1
if [ -d ssh ]; then
	cd ssh || {
		printf "%s - Failed to enter ssh directory\n" "${ERROR}"
		exit 1
	}
else
	printf "\n${NOTE} Cloning ssh. " && git clone https://github.com/nhattruongNeoVim/ssh --depth 1 || {
		printf "%s - Failed to clone dotfiles \n" "${ERROR}"
		exit 1
	}
	cd ssh || {
		printf "%s - Failed to enter ssh directory\n" "${ERROR}"
		exit 1
	}
fi

# configure GitHub
printf "${NOTE} Configuring GitHub\n\n"
git config --global user.name "nhattruongNeoVim" && { echo "${OK} Set username successfully!"; } || {
	echo "${ERROR} Failed to set username"
}
git config --global user.email "nhattruong13112000@gmail.com" && { echo "${OK} Set user email successfully!"; } || {
	echo "${ERROR} Failed to set user email"
}

# configuring SSH
SSH_DIR="$HOME/.ssh"
if [ ! -d "$SSH_DIR" ]; then
	mkdir -p "$SSH_DIR"
fi

# copying SSH directory
cp -r .ssh "$SSH_DIR" && { echo "${OK} Copied .ssh directory successfully!"; } || {
    echo "${ERROR} Failed to copy .ssh directory"
}

# changing permissions
chmod 600 "$SSH_DIR/id_ed25519" && { echo "${OK} Changed permissions successfully!"; } || {
    echo "${ERROR} Failed to change permissions"
}

# generating public key if it doesn't exist
if [ ! -f "$SSH_DIR/id_ed25519.pub" ]; then
    ssh-keygen -y -f "$SSH_DIR/id_ed25519" > "$SSH_DIR/id_ed25519.pub"
fi
