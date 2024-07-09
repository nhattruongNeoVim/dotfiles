#!/bin/bash

print_msg() {
    local msg_type=$1
    local msg=$2
    local color
    case $msg_type in
        NOTE) color="\e[34m" ;;
        OK) color="\e[32m" ;;
        ERROR) color="\e[31m" ;;
        *) color="\e[0m" ;;
    esac
    printf "\n%s%s - %s\e[0m\n" "$color" "$msg_type" "$msg"
}
print_msg "NOTE" "Installing packages..."
