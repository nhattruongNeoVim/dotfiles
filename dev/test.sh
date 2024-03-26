#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
RESET="$(tput sgr0)"

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

# echo "SPACE = select/unselect a profile. RETURN = confirm. No selection = CANCEL"
# choose=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "≤ 1080p" "≥ 1440p")
#
# if [ "$choose" == "≤ 1080p" ]; then
# 	echo "Please"
# elif [ "$choose" == "≥ 1440p" ]; then
# 	echo "ok"
# elif [ "$choose" == "≤ 1080p ≥ 1440p" ]; then
# 	echo "nhattruongNeoVim"
# else
#     echo $choose
# fi
#

while true; do
	number=$(gum input --prompt="--> " --placeholder "Enter the battery charge limit (as a percentage):")
	echo $number
	if [[ "$number" =~ ^[0-9]+$ && "$number" -ge 0 && "$number" -le 100 ]]; then
		if [[ -d "/sys/class/power_supply/BAT0" ]]; then
			battery="BAT0"
		elif [[ -d "/sys/class/power_supply/BAT1" ]]; then
			battery="BAT1"
		else
			echo "${ERROR} Battery not found."
			exit 1
		fi

		printf "\n${CAT} Configuring systemd unit for $battery ... \n"
		{
			echo "[Unit]"
			echo "Description=Set battery charge limit for $battery"
			echo "After=multi-user.target"
			echo ""
			echo "[Service]"
			echo "Type=oneshot"
			echo "ExecStart=/bin/bash -c 'echo $number > /sys/class/power_supply/$battery/charge_control_end_threshold'"
			echo ""
			echo "[Install]"
			echo "WantedBy=multi-user.target"
		}

		printf "\n${OK} Done\n"
		break
	else
		echo "${ERROR} Invalid input. Please enter a valid number between 0 and 100."
	fi
done
