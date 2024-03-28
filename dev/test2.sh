#!/bin/bash

OK() {
	ak=$(gum style \
		--foreground 213 --border-foreground 213 --border rounded \
		--align center --width 10 --margin "0 0" --padding "0 0" \
        "$1")
	al=$(gum style \
		--foreground 213 --border-foreground 213 --border rounded \
		--align center  --margin "0 0" --padding "0 0" \
        "$2")
    gum join --horizontal "$ak" "$al"
}
OK "OK" "zsh was installed" 
