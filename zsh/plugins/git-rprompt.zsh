# ZSH RPROMPT containing simple Git status

git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
git_prompt_status() {
    # Get the status of the working tree
    INDEX=$(command git status --porcelain -b 2> /dev/null)
    RESET='%f'
    STATUS=""
    if $(echo "$INDEX" | grep -E '^\?\? ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$RESET$STATUS"
    elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$RESET$STATUS"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$RESET$STATUS"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$RESET$STATUS"
    elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$RESET$STATUS"
    elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$RESET$STATUS"
    fi
    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## .*ahead' &> /dev/null); then
        AHEAD=$(echo "$INDEX" | sed -nE 's/.*ahead\s([0-9]*).*/\1/p')
        STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$AHEAD$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## .*behind' &> /dev/null); then
        BEHIND=$(echo "$INDEX" | sed -nE 's/.*behind\s([0-9]*).*/\1/p')
        STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$BEHIND$RESET$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## .*diverged' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED$RESET$STATUS"
    fi
    echo $STATUS
}

# Required for dynamic prompt
setopt prompt_subst

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_AHEAD="%F{green}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{red}↓"

ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}~"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{yellow}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{cyan}?"

RPROMPT="\$(git_prompt_info)\$(git_prompt_status)%{\$reset_color%}$RPROMPT"
