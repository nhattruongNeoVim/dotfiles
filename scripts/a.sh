#!/bin/bash
# Custom grub #

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Variables
theme="BlackSwan"
grub="/etc/default/grub"
grub_theme="/boot/grub/themes/$theme/theme.txt"

# Check and update GRUB_DISABLE_OS_PROBER
if grep -q "^.*GRUB_DISABLE_OS_PROBER=" "$grub"; then
	sudo sed -i "s|^.*GRUB_DISABLE_OS_PROBER=.*|GRUB_DISABLE_OS_PROBER=false|" "$grub"
	echo "${OK} Updated GRUB_DISABLE_OS_PROBER in $grub"
fi

if [ -f "$grub" ]; then
	if grep -q "^.*GRUB_THEME=" "$grub"; then
		sudo sed -i "s|^.*GRUB_THEME=.*|GRUB_THEME=\"$grub_theme\"|" "$grub"
		echo "${OK} Updated GRUB_THEME in $grub"
	else
		# If GRUB_THEME doesn't exist, add it to grub file
		echo "GRUB_THEME=\"$grub_theme\"" | sudo tee -a "$grub" >/dev/null
		echo "${OK} Added GRUB_THEME to $grub"
	fi
else
	echo "${WARN} $grub does not exist"
	break
fi
