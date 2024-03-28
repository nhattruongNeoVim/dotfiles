#!/bin/bash
# For disabling touchpad.

touchpad=$(hyprctl devices | grep touchpad | sed -e 's/\s*//')
settings_file="$HOME/.config/hypr/configs/settings.conf"
notif="$HOME/.config/swaync/images/bell.png"

toggle_touchpad() {
    enabled=$(awk '/device/,/^}/{if ($1 == "enabled") print $3}' "$settings_file" | tr -d '[:space:]')

    if [[ "$enabled" == "true" ]]; then
        action="false"
    else
        action="true"
    fi
    
    sed -i "/device/,/^}/{s/name = .*/name = $touchpad/; s/enabled = $enabled/enabled = $action/}" "$settings_file"
    
    notify-send -u low -i "$notif" "Touchpad enabled $action"
}

toggle_touchpad
