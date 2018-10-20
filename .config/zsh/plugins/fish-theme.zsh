# ZSH Theme emulating the Fish shell's default prompt.

_fishy_collapsed_wd() {
    pwd | sed -E 's|^'$HOME'|~|;s|(.*)/|\1%|;s|((^\|/)\.?[^/%]{1})[^/%]*|\1|g;s|(.*)%|\1/|'
}

# Required for dynamic prompt
setopt prompt_subst

local user_color='green'; [ $UID -eq 0 ] && user_color='red'
PROMPT="%n@%m %F{$user_color}\$(_fishy_collapsed_wd)%f%(!.#.>) "
PROMPT2='%F{red}\ %f'

local return_status="%F{red}%(?..%?)%f"
RPROMPT='${return_status}%{$reset_color%}'
