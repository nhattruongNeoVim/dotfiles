#!/bin/bash
# Hyprland Packages

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# start script
aur_pkgs=(
	microsoft-edge-stable
	arttime-git
	shell-color-scripts
	pipes.sh
	tgpt-bin
    vmware-workstation
    # xampp
)

hypr_pkgs=(
	gvfs
	gvfs-mtp
	imagemagick
	kitty
	kvantum
	python-requests
	qt6-svg
	rofi-lbonn-wayland-git
	swaylock-effects-git
	swaync
	swww
	wlogout
	cava
	eog
	mousepad
	nwg-look-bin
	pacman-contrib
)

fonts=(
	adobe-source-code-pro-fonts
	noto-fonts-emoji
	otf-font-awesome
	ttf-droid
	ttf-fira-code
	ttf-jetbrains-mono
	ttf-jetbrains-mono-nerd
)

# List of packages to uninstall as it conflicts with swaync or causing swaync to not function properly
uninstall=(
	dunst
	mako
)

# Checking if mako or dunst is installed
printf "\n%s - Checking if mako or dunst are installed and removing for swaync to work properly \n" "${NOTE}"
for PKG in "${uninstall[@]}"; do
	uninstall_pacman_pkg "$PKG"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG uninstallation had failed"
	fi
done

# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"
for PKG1 in "${hypr_pkgs[@]}" "${fonts[@]}" "${aur_pkgs[@]}"; do
	install_aur_pkg "$PKG1"
	if [ $? -ne 0 ]; then
		echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed"
	fi
done

printf "\n%s - Initializing vmware.... \n" "${NOTE}"
sudo modprobe -a vmw_vmci vmmon && { echo "${OK} Enable vmware module successfully!"; } || {
	echo "${ERROR} Failed to enable vmware module"
}
sudo systemctl enable --now vmware-networks.service && { echo "${OK} Enable vmware network service successfully!"; } || {
	echo "${ERROR} Failed to enable vmware network service"
}
sudo systemctl enable --now vmware-usbarbitrator.service && { echo "${OK} Enable vmware usb service successfully!"; } || {
	echo "${ERROR} Failed to enable vmware usb service"
}
