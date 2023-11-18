# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export VISUAL="$HOME/.local/bin/nvim"

# NeoVim Switcher
alias nvim-chad="NVIM_APPNAME=NvChad nvim"
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=Kickstart nvim"
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

function nvims() {
  items=("Default" "Kickstart" "NvChad" "LazyVim" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --no-sort --preview-window=wrap --preview='echo "nhattruongNeoVim"' --prompt=" Neovim Config  " --height=10% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "Default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# Nala
alias snuu='sudo nala update && sudo nala upgrade -y'
alias snu='sudo nala update'
alias sai='sudo apt install -y'
alias snr='sudo nala remove'

# Apt
alias sauu='sudo apt update && sudo apt upgrade -y'
alias sau='sudo apt update'
alias sni='sudo nala install -y'
alias sar='sudo apt remove'
alias saa='sudo add-apt-repository'

# Git
alias ga='git add .'
alias gs='git status'
alias gc='git commit -m'
alias gp='git push origin master'
alias gg="git add . && git commit -m 'update' && git push origin master"

alias vim='nvims'
alias nf='neofetch'
alias pipes='pipes.sh'
alias dl='aria2c --optimize-concurrent-downloads -j 16 -s 16 -x 16 -k 4M'
alias ls='lsd'
alias la='lsd -la'
alias ll='lsd -ll'
alias lt='lsd --tree'
alias ltl='lsd --tree --long'
alias cd..='cd ..'
alias cd-='cd -'
alias bat='batcat'
alias cf='cpufetch'
alias nf='neofetch'
alias btop='bpytop'
alias matrix='cmatrix'
alias hack='hollywood'
alias lc='lolcat'
alias win='sudo efibootmgr --bootnext 0006 && reboot'
alias ip="echo $(ifconfig | grep broadcast | awk '{print $2}')"
alias time="arttime --nolearn -a kissingcats -b kissingcats2 -t 'nhattruongNeoVim' --ac 6"

figlet -f ANSIShadow "nhat truong" | lolcat -F 0.2