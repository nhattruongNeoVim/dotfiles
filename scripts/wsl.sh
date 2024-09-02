#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib) && clear

# check if the system is running under WSL and determine the distribution
if sudo hostnamectl | grep -q 'Virtualization: wsl'; then
    if sudo hostnamectl | grep -q 'Ubuntu'; then
        exScriptWsl "ubuntu.sh"
    elif sudo hostnamectl | grep -q 'Arch'; then
        exScriptWsl "arch.sh"
    else
        echo "${ERROR} This script is only available on ubuntu or arch distributions."
    fi
else
    echo "${NOTE} This script is only available under Windows Subsystem for Linux (WSL)."
fi
