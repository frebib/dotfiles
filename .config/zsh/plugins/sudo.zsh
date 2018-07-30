# Source: https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/sudo/sudo.plugin.zsh

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]] || [[ $BUFFER == vi\ * ]] || [[ $BUFFER == vim\ * ]]; then
        LBUFFER="s$LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]] || [[ $BUFFER == svi\ * ]]|| [[ $BUFFER == svim\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="${LBUFFER#s}"
    else
        LBUFFER="sudo $LBUFFER"
    fi

    _zsh_highlight
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
