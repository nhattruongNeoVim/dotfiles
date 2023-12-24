#!/bin/bash

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

echo -e "\e[34m   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____ "
echo -e "  |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |"
echo -e "  |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|"
echo -e "  |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |"
echo -e "  |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |"
echo -e "  |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |"
echo -e "  |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|"
echo -e ""
echo -e ""
echo -e "-------------------- Script developed by nhattruongNeoVim --------------------"
echo -e " -------------- Github: https://github.com/nhattruongNeoVim -----------------"
echo -e ""

# initialize variables
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)
LOG="install-$(date +%d-%H%M%S)_dotfiles.log"

git clone -b hyprland https://github.com/nhattruongNeoVim/dotfiles ~/dotfiles --depth 1 && cd ~/dotfiles

# update home folders
xdg-user-dirs-update 2>&1 | tee -a "$LOG" || true

# uncommenting WLR_NO_HARDWARE_CURSORS if nvidia is detected
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
  # NVIDIA GPU detected, uncomment line 23 in ENVariables.conf
  sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' config/hypr/configs/ENVariables.conf
  sed -i '/env = LIBVA_DRIVER_NAME,nvidia/s/^#//' config/hypr/configs/ENVariables.conf
  sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^#//' config/hypr/configs/ENVariables.conf
fi

# uncommenting WLR_RENDERER_ALLOW_SOFTWARE,1 if running in a VM is detected
if hostnamectl | grep -q 'Chassis: vm'; then
  echo "This script is running in a virtual machine."
  sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' config/hypr/configs/ENVariables.conf
  sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' config/hypr/configs/ENVariables.conf
  sed -i '/monitor = Virtual-1, 1920x1080@60,auto,1/s/^#//' config/hypr/configs/Monitors.conf
fi

# Preparing hyprland.conf to check for current keyboard layout
# Function to detect keyboard layout in an X server environment
detect_x_layout() {
  if command -v setxkbmap >/dev/null 2>&1; then
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

# Function to detect keyboard layout in a tty environment
detect_tty_layout() {
  if command -v localectl >/dev/null 2>&1; then
    layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
    if [ -n "$layout" ]; then
      echo "$layout"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

# Detect the current keyboard layout based on the environment
if [ -n "$DISPLAY" ]; then
  # System is in an X server environment
  layout=$(detect_x_layout)
else
  # System is in a tty environment
  layout=$(detect_tty_layout)
fi

echo "Keyboard layout: $layout"

printf "${NOTE} Detecting keyboard layout to prepare necessary changes in hyprland.conf before copying\n\n"

# Prompt the user to confirm whether the detected layout is correct
while true; do
    read -p "$ORANGE Detected keyboard layout or keymap: $layout. Is this correct? [y/n] " confirm

    case $confirm in
        [yY])
            # If the detected layout is correct, update the 'kb_layout=' line in the file
            awk -v layout="$layout" '/kb_layout/ {$0 = "  kb_layout=" layout} 1' config/hypr/configs/Settings.conf > temp.conf
            mv temp.conf config/hypr/configs/Settings.conf
            break ;;
        [nN])
            printf "\n%.0s" {1..2}
            echo "$(tput bold)$(tput setaf 3)ATTENTION!!!! VERY IMPORTANT!!!! $(tput sgr0)" 
            echo "$(tput bold)$(tput setaf 7)Setting a wrong value here will result in Hyprland not starting $(tput sgr0)"
            echo "$(tput bold)$(tput setaf 7)If you are not sure, keep it in us layout. You can change later on! $(tput sgr0)"
            echo "$(tput bold)$(tput setaf 7)You can also set more than 2 layouts!$(tput sgr0)"
            echo "$(tput bold)$(tput setaf 7)ie: us,kr,es $(tput sgr0)"
            printf "\n%.0s" {1..2}
            read -p "${CAT} - Please enter the correct keyboard layout: " new_layout
            # Update the 'kb_layout=' line with the correct layout in the file
            awk -v new_layout="$new_layout" '/kb_layout/ {$0 = "  kb_layout=" new_layout} 1' config/hypr/configs/Settings.conf > temp.conf
            mv temp.conf config/hypr/configs/Settings.conf
            break ;;
        *)
            echo "Please enter either 'y' or 'n'." ;;
    esac
done

printf "\n"

# Action to do for better rofi appearance
while true; do
    echo "$ORANGE Select monitor resolution for better Rofi appearance:"
    echo "$YELLOW 1. Equal to or less than 1080p (≤ 1080p)"
    echo "$YELLOW 2. Equal to or higher than 1440p (≥ 1440p)"
    read -p "$CAT Enter the number of your choice: " choice

    case $choice in
        1)
            resolution="≤ 1080p"
            break
            ;;
        2)
            resolution="≥ 1440p"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1 for ≤ 1080p or 2 for ≥ 1440p."
            ;;
    esac
done

# Use the selected resolution in your existing script
echo "You chose $resolution resolution for better Rofi appearance."

# Add your commands based on the resolution choice
if [ "$resolution" == "≤ 1080p" ]; then
    cp -r config/rofi/resolution/1080p/* config/rofi/
elif [ "$resolution" == "≥ 1440p" ]; then
    cp -r config/rofi/resolution/1440p/* config/rofi/
fi

printf "\n%.0s" {1..2}

### Copy Config Files ###
set -e # Exit immediately if a command exits with a non-zero status.

printf "${NOTE} - copying dotfiles\n"
# Function to create a unique backup directory name with month, day, hours, and minutes
get_backup_dirname() {
  local timestamp
  timestamp=$(date +"%m%d_%H%M")
  echo "back-up_${timestamp}"
}

for DIR in btop cava dunst hypr kitty Kvantum qt5ct qt6ct rofi swappy swaylock wal waybar wlogout; do 
  DIRPATH=~/.config/"$DIR"
  if [ -d "$DIRPATH" ]; then 
    echo -e "${NOTE} - Config for $DIR found, attempting to back up."
    BACKUP_DIR=$(get_backup_dirname)
    mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR" 2>&1 | tee -a "$LOG"
    echo -e "${NOTE} - Backed up $DIR to $DIRPATH-backup-$BACKUP_DIR."
  fi
done

for DIRw in wallpapers; do 
  DIRPATH=~/Pictures/"$DIRw"
  if [ -d "$DIRPATH" ]; then 
    echo -e "${NOTE} - Wallpapers in $DIRw found, attempting to back up."
    BACKUP_DIR=$(get_backup_dirname)
    mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR" 2>&1 | tee -a "$LOG"
    echo -e "${NOTE} - Backed up $DIRw to $DIRPATH-backup-$BACKUP_DIR."
  fi
done

printf "\n%.0s" {1..2}

# Copying config files
mkdir -p ~/.config
cp -r config/* ~/.config/ && { echo "${OK}Copy completed!"; } || { echo "${ERROR} Failed to copy config files."; exit 1; } 2>&1 | tee -a "$LOG"

# copying Wallpapers
mkdir -p ~/Pictures/wallpapers
cp -r wallpapers ~/Pictures/ && { echo "${OK}Copy completed!"; } || { echo "${ERROR} Failed to copy wallpapers."; exit 1; } 2>&1 | tee -a "$LOG"
 
# Set some files as executable
chmod +x ~/.config/hypr/scripts/* 2>&1 | tee -a "$LOG"

# Set executable for initial-boot.sh
chmod +x ~/.config/hypr/initial-boot.sh 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..3}

# additional wallpapers
while true; do
    read -rp "${CAT} Would you like to download additional wallpapers? (y/n)" WALL
    case $WALL in
        [Yy])
            echo "${NOTE} Downloading additional wallpapers..."
            if git clone "https://github.com/nhattruongNeoVim/wallpaper-bank --depth 1"; then
                echo "${NOTE} Wallpapers downloaded successfully."

                if cp -R wallpaper-bank/wallpapers/* ~/Pictures/wallpapers/ >> "$LOG" 2>&1; then
                    echo "${NOTE} Wallpapers copied successfully."
                    rm -rf Wallpaper-Bank 2>&1 # Remove cloned repository after copying wallpapers
                    break
                else
                    echo "${ERROR} Copying wallpapers failed" >&2
                fi
            else
                echo "${ERROR} Downloading additional wallpapers failed" >&2
            fi
            ;;
        [Nn])
            echo "You chose not to download additional wallpapers." >&2
            break
            ;;
        *)
            echo "Please enter 'y' or 'n' to proceed."
            ;;
    esac
done


printf "\n%.0s" {1..3}

# Detect machine type and set Waybar configurations accordingly, logging the output
if hostnamectl | grep -q 'Chassis: desktop'; then
    # Configurations for a desktop
    ln -sf "$HOME/.config/waybar/configs/[TOP] Default" "$HOME/.config/waybar/config" 2>&1 | tee -a "$LOG"
    rm -r "$HOME/.config/waybar/configs/[TOP] Default Laptop" "$HOME/.config/waybar/configs/[BOT] Default Laptop" 2>&1 | tee -a "$LOG"
else
    # Configurations for a laptop or any system other than desktop
    ln -sf "$HOME/.config/waybar/configs/[TOP] Default Laptop" "$HOME/.config/waybar/config" 2>&1 | tee -a "$LOG"
    rm -r "$HOME/.config/waybar/configs/[TOP] Default" "$HOME/.config/waybar/configs/[BOT] Default" 2>&1 | tee -a "$LOG"
fi

# symlinks for waybar style
ln -sf "$HOME/.config/waybar/style/[Pywal] Chroma Fusion.css" "$HOME/.config/waybar/style.css" && \

# initialize pywal to avoid config error on hyprland
wallpaper=$HOME/Pictures/wallpapers/anime-girl-abyss.png
wal -i $wallpaper -s -t 2>&1 | tee -a "$LOG"

#initial symlink for Pywal Dark and Light for Rofi Themes
ln -sf "$HOME/.cache/wal/colors-rofi-dark.rasi" "$HOME/.config/rofi/pywal-color/pywal-theme.rasi"

echo "${NOTE} Remove dotfile." && cd ~ && rm -rf dotfiles

printf "\n%.0s" {1..2}
printf "\n${OK} Copy Completed!\n\n\n"
printf "${ORANGE} ATTENTION!!!! \n"
printf "${ORANGE} YOU NEED to logout and re-login or reboot to avoid issues\n\n"
