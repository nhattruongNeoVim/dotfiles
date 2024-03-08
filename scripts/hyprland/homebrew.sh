OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

if command -v brew &>/dev/null; then
	printf "\n%s - Snap already installed, moving on.\n" "${OK}"
else
	printf "\n%s - Snap was NOT located\n" "${NOTE}"
	printf "\n%s - Installing Homebrew\n" "${NOTE}"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
		printf "%s - Failed to clone snap from\n" "${ERROR}"
		exit 1
	}
fi

# Setup Homebrew before proceeding
printf "\n%s - Set up snap.... \n" "${NOTE}"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/albedo/.zshrc && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || {
    printf "%s - Failed to setup snap\n" "${ERROR}"
    exit 1
}
