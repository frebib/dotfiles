# ZSH Theme emulating the Fish shell's default prompt.

_fishy_collapsed_wd() {
    pwd | sed -E 's|^'$HOME'|~|;s|(.*)/|\1%|;s|((^\|/)\.?[^/%]{1})[^/%]*|\1|g;s|(.*)%|\1/|'
}

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd) printf '\e[3 q';; # block cursor
    *)     printf '\e[2 q';; # less visible cursor
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Required for dynamic prompt
setopt prompt_subst

local user_color='green'; [ $UID -eq 0 ] && user_color='red'
PROMPT="%n@%m %F{$user_color}\$(_fishy_collapsed_wd)%f%(!.#.>) "
PROMPT2='%F{red}\ %f'

RPROMPT='%F{cyan}${${KEYMAP/vicmd/ normal}/(main|viins)/}%f%(?.. %F{red}%?%f)'

# Disable trailing space
# https://superuser.com/questions/655607/removing-the-useless-space-at-the-end-of-the-right-prompt-of-zsh-rprompt
ZLE_RPROMPT_INDENT=0
