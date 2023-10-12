#!/bin/sh

echo "   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____ "
echo "  |    \\ |  |  | /    ||      |    |      ||    \\ |  |  | /   \ |    \\  /    |"
echo "  |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|"
echo "  |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |"
echo "  |  |  ||  |  ||  _  |  |  |        |  |  |    \\ |  :  ||     ||  |  ||  |_ |"
echo "  |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |"
echo "  |__|__||__|__||__|__|  |__|        |__|  |__|\\_| \\__,_| \\___/ |__|__||___,_|"
echo ""
echo ""
echo "-------------------- Script developed by nhattruongNeoVim --------------------"
echo " -------------- Github: https://github.com/nhattruongNeoVim -----------------"
echo ""

# Function util
write_start() {
    echo ">> $1"
}

write_done() {
    echo "Done"
}

write_ask() {
    echo -n ">> $1"
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
