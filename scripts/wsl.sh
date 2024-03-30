#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

clear
if hostnamectl | grep -q 'Ubuntu'; then
    exScriptWsl "ubuntu.sh"
elif hostnamectl | grep -q 'Arch'; then
    exScriptWsl "arch.sh"
fi
