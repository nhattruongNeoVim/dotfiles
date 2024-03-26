#!/bin/bash

# echo "Please choose between the main-release or the rolling-release (development version):"
# version=$(gum choose "main-release" "rolling-release")
# if [ "$version" == "main-release" ]; then
#     echo 'aaa'
# elif [ "$version" == "rolling-release" ]; then
#     echo 'bbb'
# else
# 	exit 130
# fi
# echo ":: Download complete."

# choose=$(gum confirm "How do you want to proceed?" --affirmative "≤ 1080p" --negative "≥ 1440p")
# choose=$(gum choose "≤ 1080p" "≥ 1440p")

echo "SPACE = select/unselect a profile. RETURN = confirm. No selection = CANCEL"
choose=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "≤ 1080p" "≥ 1440p")

if [ "$choose" == "≤ 1080p" ]; then
	echo "Please"
elif [ "$choose" == "≥ 1440p" ]; then
	echo "ok"
elif [ "$choose" == "≤ 1080p ≥ 1440p" ]; then
	echo "nhattruongNeoVim"
else
    echo $choose
fi
