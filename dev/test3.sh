#!/bin/bash

# source <(curl -sSL https://is.gd/arch_library)
#
# ask_custom_option() {
#     if gum confirm "$CAT $1" --affirmative "$2" --negative "$3" ;then
# 		eval "$4=$2"
# 		echo "$CAT $1 $YELLOW ${!4}"
# 	else
# 		eval "$4=$3"
# 		echo "$CAT $1 $YELLOW ${!4}"
# 	fi
# }
#
# ask_custom_option "Choose your AUR helper" "yay" "paru" aur_helper

mess() {
	gum style \
		--foreground 213 --border-foreground 213 --border rounded \
		--align center --margin "0 0" --padding "0 0" \
		"$1"
}
mess "$(tput setaf 2)[OK]$(tput sgr0)"
# OK=$(mess "$(tput setaf 2)[OK]$(tput sgr0)")
OK="$(tput setaf 2)[OK]$(tput sgr0)"
echo $OK
mess $OK
