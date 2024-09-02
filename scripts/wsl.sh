#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib) && clear

# Get system information
sys_info=$(sudo hostnamectl)

# Check if the system is running under WSL
if echo "$sys_info" | grep -q 'WSL2'; then
    if echo "$sys_info" | grep -q 'Ubuntu'; then
        exScriptWsl "ubuntu.sh"
    elif echo "$sys_info" | grep -q 'Arch'; then
        exScriptWsl "arch.sh"
    else
        echo "${ERROR} This script is only available on Ubuntu or Arch distributions."
    fi
else
    echo "${NOTE} This script is only available under Windows Subsystem for Linux (WSL)."
fi
