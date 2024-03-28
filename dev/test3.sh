#!/bin/bash


ask_custom_option() {
    if gum confirm "$CAT $1" --affirmative "$2" --negative "$3" ;then
		eval "$4=$2"
		echo "$CAT $1 $YELLOW ${!4}"
	else
		eval "$4=$3"
		echo "$CAT $1 $YELLOW ${!4}"
	fi
}

ask_custom_option "Choose your AUR helper" "yay" "paru" aur_helper
