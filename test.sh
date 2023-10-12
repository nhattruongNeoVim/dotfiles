# !/bin/bash

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

# Function util
write_start() {
    echo -e "\e[32m>> $1\e[0m"
}

write_done() {
    echo -e "\e[34mDone\e[0m"
}

write_ask() {
    echo -en "\e[32m>> $1\e[0m"
}

# Start script
# Set local time
write_ask "Are you dual booting Windows and Ubuntu? (y/n): "
read answer
if [ "$answer" = 'y' ]; then
    write_start "I will set the local time on Ubuntu to display the correct time on Windows."
    echo 'timedatectl set-local-rtc 1 --adjust-system-clock'
fi
write_done
