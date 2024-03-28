#!/bin/bash

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

echo "${NOTE} This script will add your user to the 'input' group."
echo "${NOTE} Please note that adding yourself to the 'input' group might be necessary for waybar keyboard-state functionality."

if gum confirm "${YELLOW}Do you want to proceed?${RESET}"; then
	# Check if the 'input' group exists
	if grep -q '^input:' /etc/group; then
		echo "${OK} 'input' group exists."
	else
		echo "${NOTE} 'input' group doesn't exist. Creating 'input' group..."
		sudo groupadd input
		echo "'input' group created"
	fi

	# Add the user to the input group
	sudo usermod -aG input "$(whoami)"
	echo "${OK} User added to the 'input' group. Changes will take effect after you log out and log back in."
	echo "User added to 'input' group"
else
	echo "${NOTE} No changes made. Exiting the script."
fi
