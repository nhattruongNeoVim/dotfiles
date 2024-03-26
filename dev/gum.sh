#!/bin/sh
# https://github.com/charmbracelet/gum
# TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
# SCOPE=$(gum input --placeholder "scope")
#
# # Since the scope is optional, wrap it in parentheses if it has a value.
# test -n "$SCOPE" && SCOPE="($SCOPE)"
#
# # Pre-populate the input with the type(scope): so that the user may change it
# SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
# DESCRIPTION=$(gum write --placeholder "Details of this change (CTRL+D to finish)")
#
# # Commit these changes
# gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
# gum input --cursor.foreground "#FF0" --prompt.foreground "#0FF" --prompt "* " \
#     --placeholder "What's up?" --width 80 --value "Not much, hby?"
# export GUM_INPUT_CURSOR_FOREGROUND="#FF0"
# export GUM_INPUT_PROMPT_FOREGROUND="#0FF"
# export GUM_INPUT_PLACEHOLDER="What's up?"
# export GUM_INPUT_PROMPT="* "
# export GUM_INPUT_WIDTH=80
#
# # Uses values configured through environment variables above but can still be
# # overridden with flags.
# # gum input
# gum input --password > password.txt
# echo Strawberry >> flavors.txt
# echo Banana >> flavors.txt
# echo Cherry >> flavors.txt
# cat flavors.txt | gum filter > selection.txt

# echo "Pick a card, any card..."
# CARD=$(gum choose --height 15 {{A,K,Q,J},{10..2}}" "{♠,♥,♣,♦})
# echo "Was your card the $CARD?"

# gum confirm && touch file.txt || echo "File"

# batcat $(gum file $HOME)

# gum pager < $HOME/install.log

# gum spin --spinner dot --title "Buying Bubble Gum..." -- sleep 2

gum style \
	--foreground 213 --border-foreground 213 --border rounded \
	--align center --width 90 --margin "1 2" --padding "2 4" \
	"  ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____  " \
	" |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    | " \
	" |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __| " \
	" |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  | " \
	" |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ | " \
	" |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     | " \
	" |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_| " \
	"                                                                              " \
	" ------------------- Script developed by nhattruongNeoVim ------------------- " \
	"                                                                              " \
	"  -------------- Github: https://github.com/nhattruongNeoVim ---------------  " \
	"                                                                              "

gum style \
	--foreground 6 --border-foreground 6 --border rounded \
	--align left --width 105 --margin "1 2" --padding "2 4" \
	"NOTE: Ensure that you have a stable internet connection $(tput setaf 3)(Highly Recommended!!!!)" \
	"                                                                                               " \
	"NOTE: You will be required to answer some questions during the installation!!                  " \
	"                                                                                               " \
	"NOTE: If you are installing on a VM, ensure to enable 3D acceleration else Hyprland wont start!"
