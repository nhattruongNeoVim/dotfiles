#!/bin/bash

# source library
source <(curl -sSL https://is.gd/arch_library)

# start script
echo -e "${NOTE} Setting up battery charge limit."

if hostnamectl | grep -q 'Chassis: vm' || hostnamectl | grep -q 'Chassis: desktop'; then
	echo -e "${NOTE} Setting up battery charge limit is not applicable on desktop or virtual machine. Skipping..."
	exit 1
fi

while true; do
    echo 

	number=$(gum input --prompt="--> " --placeholder "Enter the battery charge limit (as a percentage):")

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
		} | sudo tee "/etc/systemd/system/charge_limit_battery.service" >/dev/null

		sudo systemctl enable --now charge_limit_battery.service

		printf "\n${OK} Done\n"
		break
	else
		echo "${ERROR} Invalid input. Please enter a valid number between 0 and 100."
	fi
done
