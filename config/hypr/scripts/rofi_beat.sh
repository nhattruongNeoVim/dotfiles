#!/bin/bash

# Directory for icons
iDIR="$HOME/.config/swaync/icons"

# Note: You can add more options below with the following format:
# ["TITLE"]="link"

# Define menu options as an associative array
declare -A menu_options=(
	["Remix việt"]="https://youtu.be/wnuIlvOSFK0?si=8tqUEMrKzyu9S9bD"
	["Playlist việt"]="https://youtube.com/playlist?list=PLJOwSCcWqDV1DMnF0xU0khtDjrB_2w9PL&si=4jtQMXrHTdmgN6PT"
	["Playlist trung"]="https://youtube.com/playlist?list=PLJOwSCcWqDV1ZVbvGLyJvTjFByhncWHuP&si=qdSAy067FMAiANXf"
	["Top Youtube Music 2023"]="https://youtube.com/playlist?list=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&si=y7qNeEVFNgA-XxKy"
	["Chillhop"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
	["SmoothChill"]="https://media-ssl.musicradio.com/SmoothChill"
	["Relaxing Music"]="https://youtube.com/playlist?list=PLMIbmfP_9vb8BCxRoraJpoo4q1yMFg4CE"
	["Youtube Remix"]="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"
	["Korean Drama OST"]="https://youtube.com/playlist?list=PLUge_o9AIFp4HuA-A3e3ZqENh63LuRRlQ"
)

# Function for displaying notifications
notification() {
	notify-send -u normal -i "$iDIR/music.png" "Playing now: $@"
}

# Main function
main() {
	choice=$(printf "%s\n" "${!menu_options[@]}" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -i -p "")

	if [ -z "$choice" ]; then
		exit 1
	fi

	link="${menu_options[$choice]}"

	notification "$choice"

	# Check if the link is a playlist
	if [[ $link == *playlist* ]]; then
		mpv --shuffle --vid=no "$link"
	else
		mpv --vid=no "$link"
	fi
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -u low -i "$iDIR/music.png" "Online Music stopped" || main
