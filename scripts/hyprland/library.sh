#!/bin/bash
# global function

# set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

mess() {
	mess1=$(gum style \
		--foreground 213 --border-foreground 213 --border rounded \
		--align center --margin "0 0" --padding "0 0" \
		"$1")
	mess2=$(gum style \
		--foreground 213 --border-foreground 213 --border rounded \
		--align center --margin "0 0" --padding "0 0" \
		"$2")
	gum join --horizontal "$mess1" "$mess2"
}

install_pacman_pkg() {
	if pacman -Q "$1" &>/dev/null; then
		# echo -e "${OK} $1 is already installed. Skipping..."
        mess "${OK}" "$1 is already installed. Skipping..."
	else
		# echo -e "${NOTE} Installing $1 ..."
        mess "${NOTE}" "Installing $1 ..."
		sudo pacman -S --noconfirm "$1"
		if pacman -Q "$1" &>/dev/null; then
			# echo -e "${OK} $1 was installed."
            mess "${OK}" "$1 was installed."
		else
			# echo -e "${ERROR} $1 failed to install. You may need to install manually."
            mess "${ERROR}" "$1$1 failed to install. You may need to install manually."
			echo "-> $1 failed to install. You may need to install manually! Sorry I have tried :(" >>$HOME/install.log
		fi
	fi
}
