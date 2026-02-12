# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="oxide"

plugins=(
    git
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
#    auto-notify
    )

source $ZSH/oh-my-zsh.sh

. ~/.bash_profile 

. ~/.bash_aliases

# # vi mode
# bindkey -v
# export KEYTIMEOUT=1
#
# setopt vi
# KEYTIMEOUT=1
# # change cursor shape in vi mode
# zle-keymap-select () {
#     if [[ $KEYMAP == vicmd ]]; then
#         # the command mode for vi
#         echo -ne "\e[3 q"
#     else
#         # the insert mode for vi
#         echo -ne "\e[1 q"
#     fi
# }
# precmd_functions+=(zle-keymap-select)
# zle -N zle-keymap-select

bindkey '^f' autosuggest-accept # Accept autosuggestions

export PATH=$PATH:/opt/homebrew/bin

export JAVA_HOME=$(/usr/libexec/java_home)

# # Rebind Ctrl-p and Ctrl-n in vi insert mode to navigate history
# bindkey -M viins '^P' up-history
# bindkey -M viins '^N' down-history

eval "$(fzf --zsh)"
