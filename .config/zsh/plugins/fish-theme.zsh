# ZSH Theme emulating the Fish shell's default prompt.

_fishy_collapsed_wd() {
    pwd | sed -E 's|^'$HOME'|~|;s|(.*)/|\1%|;s|((^\|/)\.?[^/%]{1})[^/%]*|\1|g;s|(.*)%|\1/|'
}

git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
git_prompt_status() {
    # Get the status of the working tree
    INDEX=$(command git status --porcelain -b 2> /dev/null)
    STATUS=""
    if $(echo "$INDEX" | grep -E '^\?\? ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi
    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## .*ahead' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## .*behind' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## .*diverged' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED$STATUS"
    fi
    echo $STATUS
}

# Required for dynamic prompt
setopt prompt_subst

local user_color='green'; [ $UID -eq 0 ] && user_color='red'
PROMPT="%n@%m %F{$user_color}\$(_fishy_collapsed_wd)%f%(!.#.>) "
PROMPT2='%F{red}\ %f'

local return_status="%F{red}%(?..%?)%f"
RPROMPT='${return_status}$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"
