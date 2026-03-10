# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="oxide"
ZSH_THEME="robbyrussell"

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

bindkey '^f' autosuggest-accept # Accept autosuggestions

export PATH=$PATH:/opt/homebrew/bin

export JAVA_HOME=$(/usr/libexec/java_home)

eval "$(fzf --zsh)"

# Widget to select and execute SSH alias from .bash_aliases
# Uses BUFFER + accept-line to give SSH proper terminal access
ali-widget() {
    local alias_file="$HOME/.bash_aliases"
    local cmd=$(grep "^alias " "$alias_file" | grep "ssh" | \
                sed 's/alias \([^=]*\)=.*/\1/' | \
                fzf --preview "grep \"^alias {}=\" \"$alias_file\" | sed 's/alias [^=]*=//'")
    if [ -n "$cmd" ]; then
        BUFFER="$cmd"
        zle accept-line
    fi
}
zle -N ali-widget
bindkey '^s' ali-widget  # Ctrl+s to select and execute SSH alias

# Widget to select directory and cd into it (excludes hidden folders)
# Uses fd which is faster and respects .gitignore
cdf-widget() {
    local dir=$(fd --type d | fzf)
    if [ -n "$dir" ]; then
        BUFFER="cd \"$dir\""
        zle accept-line
    fi
}
zle -N cdf-widget
bindkey '^g' cdf-widget  # Ctrl+g to select and cd into directory

# Gopls for zed editor
export PATH="$PATH:$HOME/go/bin"
