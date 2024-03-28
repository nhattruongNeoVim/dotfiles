#!/bin/bash
# Thunar

# source library
source <(curl -sSL https://is.gd/arch_library)

# start script
thunar=(
	thunar
	thunar-volman
	tumbler
	ffmpegthumbnailer
	thunar-archive-plugin
)

# install thunar
printf "${NOTE} Installing Thunar Packages...\n"
for THUNAR in "${thunar[@]}"; do
	install_aur_pkg "$THUNAR"
	[ $? -ne 0 ] && {
		echo -e "\e[1A\e[K${ERROR} - $THUNAR install had failed"
	}
done
