
#!/bin/bash
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
# Config neovim switcher
while [[ true ]]; do
    write_ask "Are you want to config neovim switcher(use multiple nvim)? (y/n): "
    read answer1
    case $answer1 in
        [Yy]* )
            echo -e "\n"
            write_start "Use neovim with: LazyVim, NvChad, AstroNvim"
            write_start "git clone --depth 1 https://github.com/LazyVim/starter ~/.config/LazyVim"
            write_start "git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/NvChad"
            write_start "git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/AstroNvim"
            break;;
        [Nn]* )
            break;;
        *) 
            echo -en '\e[34m Please answer yes or no !\n'
    esac
done
