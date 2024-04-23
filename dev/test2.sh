#!/bin/bash

# source library
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

# Clone tpm
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
	echo "${NOTE} TPM (Tmux Plugin Manager) is already installed."
else
	# Clone TPM repository
	echo "${NOTE} Cloning TPM (Tmux Plugin Manager)..."
	if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth 1; then
		echo "${OK} TPM (Tmux Plugin Manager) cloned successfully!"
	else
		echo "${ERROR} Failed to clone TPM (Tmux Plugin Manager)."
	fi
fi

