#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

detect_layout() {
	if command -v localectl >/dev/null 2>&1; then
		layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
		if [ -n "$layout" ]; then
			echo "$layout"
		else
			echo "unknown"
		fi
	elif command -v setxkbmap >/dev/null 2>&1; then
		layout=$(setxkbmap -query | grep layout | awk '{print $2}')
		if [ -n "$layout" ]; then
			echo "$layout"
		else
			echo "unknown"
		fi
	else
		echo "unknown"
	fi
}
	# echo "${ORANGE} This script is running in a virtual machine."
layout=$(detect_layout)
text=$(echo -e "\t${BLUE} Detected current keyboard layout is: $layout. Is this correct? ${RESET}")
if gum confirm "${CAT} Detected current keyboard layout is: $layout. Is this correct? ${RESET}"; then
	echo "${NOTE} kb_layout $layout configured in settings.  "
fi
echo -e "\n\nYou chose $resolution resolution for better Rofi appearance.\n\n"
