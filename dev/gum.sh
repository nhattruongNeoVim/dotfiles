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

source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

gum style \
	--foreground 213 --border-foreground 213 --border rounded \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	"███████╗███████╗██╗  ██╗" \
	"╚══███╔╝██╔════╝██║  ██║" \
	"  ███╔╝ ███████╗███████║" \
	" ███╔╝  ╚════██║██╔══██║" \
	"███████╗███████║██║  ██║" \
	"╚══════╝╚══════╝╚═╝  ╚═╝"

# echo "$ORANGE SPACE = select/unselect | j/k = down/up | ENTER = confirm. No selection = CANCEL"
# profile=$(gum choose --no-limit --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " "zsh-completions" "zsh-syntax-highlighting")
#
# if [ -z "${profile}" ]; then
# 	echo "No profile selected. Installation canceled."
# 	exit
# else
# 	echo "\t $YELLOW Plugin selected: " $profile
# fi
#
# if [[ $profile == *"zsh-completions"* ]]; then
# 	zsh+=('zsh-completions')
# 	sed -i '/^# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh/s/^# *//' assets/.zshrc
# fi
# if [[ $profile == *"zsh-syntax-highlighting"* ]]; then
# 	zsh+=('zsh-syntax-highlighting')
# 	sed -i '/^# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh/s/^# *//' assets/.zshrc
# fi
#
#
	echo -e "${CAT} - Do you want to add zsh plugin (OPTIONAL)? $YELLOW Yes\n"

	echo -e "$ORANGE SPACE = select/unselect | j/k = down/up | ENTER = confirm. No selection = CANCEL"
