#!/bin/bash
# pacman adding up extra-spices #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

echo -e "${NOTE} Adding Extra Spice in pacman.conf ... ${RESET}"
pacman_conf="/etc/pacman.conf"

# Remove comments '#' from specific lines
lines_to_edit=(
	"Color"
	"CheckSpace"
	"VerbosePkgLists"
	"ParallelDownloads"
)

# Uncomment specified lines if they are commented out
for line in "${lines_to_edit[@]}"; do
	if grep -q "^#$line" "$pacman_conf"; then
		sudo sed -i "s/^#$line/$line/" "$pacman_conf"
		echo -e "${CAT} Uncommented: $line ${RESET}"
	else
		echo -e "${CAT} $line is already uncommented. ${RESET}"
	fi
done

# Add "ILoveCandy" below ParallelDownloads if it doesn't exist
if grep -q "^ParallelDownloads" "$pacman_conf" && ! grep -q "^ILoveCandy" "$pacman_conf"; then
	sudo sed -i "/^ParallelDownloads/a ILoveCandy" "$pacman_conf"
	echo -e "${CAT} Added ILoveCandy below ParallelDownloads. ${RESET}"
else
	echo -e "${CAT} ILoveCandy already exists ${RESET}"
fi

echo -e "${CAT} Pacman.conf spicing up completed ${RESET}"

# updating pacman.conf
sudo pacman -Sy
