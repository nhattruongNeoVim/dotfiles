#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

echo "$ORANGE Select monitor resolution for better Rofi appearance:"
echo -e "\t $YELLOW 1. Equal to or less than 1080p (≤ 1080p)"
echo -e "\t $YELLOW 2. Equal to or higher than 1440p (≥ 1440p)"

if gum confirm "$CAT Enter the number of your choice: " --affirmative "≤ 1080p" --negative "≥ 1440p"; then
	resolution="≤ 1080p"
else
	resolution="≥ 1440p"
fi

# Use the selected resolution in your existing script
echo "You chose $resolution resolution for better Rofi appearance."
