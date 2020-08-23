# Config and cache directory paths
ZSH_DIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
LOG_DIR="$XDG_DATA_HOME/logs"
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=999999
SAVEHIST=999999

mkdir -p "$LOG_DIR" "$(dirname "$HISTFILE")"

exists() { which $@ 0<&- 1>/dev/null 2>/dev/null; }

# Only set tty if running interactively
if exists tty && tty -s; then
    # Resolve at shell runtime
    export GPG_TTY="$(tty)"
fi

# Configure less and add colours
export LESS="-RI --mouse --wheel-lines=3"
export PAGER="less"
export MANPAGER="less -+N"
export SYSTEMD_PAGER="less $LESS"
# Disable histfile
export LESSHISTFILE=-
# Use .local/share for z instead of ~/.z
export _Z_DATA="$XDG_DATA_HOME/z"

if exists tput; then
    export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
    export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
    export LESS_TERMCAP_me=$(tput sgr0)
    export LESS_TERMCAP_so=$(tput bold; tput setaf 4) # blue
    export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
    export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
    export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
    export LESS_TERMCAP_mr=$(tput rev)
    export LESS_TERMCAP_mh=$(tput dim)
    export LESS_TERMCAP_ZN=$(tput ssubm)
    export LESS_TERMCAP_ZV=$(tput rsubm)
    export LESS_TERMCAP_ZO=$(tput ssupm)
    export LESS_TERMCAP_ZW=$(tput rsupm)
fi

# Set some useful ZSH/Bash options
setopt sharehistory extendedhistory histignorealldups histignorespace histreduceblanks
setopt pathdirs autocd autopushd extendedglob nullglob alwaystoend interactivecomments dvorak

zstyle ':completion:*:sudo|_::' environ PATH="/sbin:/usr/sbin:$PATH" HOME="/root"
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':compinstall'  filename "${ZDOTDIR:-~}/.zshrc"

export WORDCHARS='*?_[]~=&;!#$%^(){}'
x-bash-backward-kill-word(){ WORDCHARS='' zle kill-word; }
zle -N x-bash-backward-kill-word

declare -A ZINIT
ZINIT[HOME_DIR]="$XDG_CACHE_HOME/zsh/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/bin"
ZINIT[PLUGINS_DIR]="${ZINIT[HOME_DIR]}/plugins"
if [ ! -e "${ZINIT[HOME_DIR]}" ]; then
    git clone https://github.com/zdharma/zinit.git "${ZINIT[HOME_DIR]}"
fi
source "${ZINIT[HOME_DIR]}"/zinit.zsh

zinit wait lucid light-mode for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit light Aloxaf/fzf-tab
zinit light agkozak/zsh-z

zinit ice lucid ver'master' wait'0a' pick'src/bash.command-not-found'
zinit light hkbakke/bash-insulter

# Vim mode!
bindkey -v
export KEYTIMEOUT=25

# Set some key-binds
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[3;3~" delete-word
bindkey '^[^[[3~' x-bash-backward-kill-word
bindkey '^[^[[3^' x-bash-backward-kill-word
bindkey '^[[A' fzf-history-widget                   # Up (fzf)
bindkey '^[[B' fzf-history-widget                   # Down (fzf)
bindkey '^F'   fzf-file-widget                      # Ctrl+F file search (fzf)

bindkey "^F" fzf-file-widget
bindkey -M vicmd "^W" backward-delete-word

bindkey -M vicmd d vi-backward-char
bindkey -M vicmd h vi-down-line-or-history
bindkey -M vicmd t vi-up-line-or-history
bindkey -M vicmd n vi-forward-char
bindkey -M vicmd k vi-delete
bindkey -M vicmd K vi-kill-eol
bindkey -M vicmd j vi-find-next-char-skip
bindkey -M vicmd l vi-repeat-search

# Backspace across newlines when in vi-mode
bindkey -v '^?' backward-delete-char

ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=128
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")

source "$XDG_CONFIG_HOME/aliases"

# Load some manual plugins
source "$ZSH_DIR/plugins/sudo.zsh"
source "$ZSH_DIR/plugins/fish-theme.zsh"
source "$ZSH_DIR/plugins/git-rprompt.zsh"

trysource() { for f in "$@"; do source "$f" 2>/dev/null && return; done; }
trysource /usr/share/fzf/key-bindings.zsh \
          /usr/share/doc/fzf/examples/key-bindings.zsh
trysource /usr/share/doc/pkgfile/command-not-found.zsh # pkgfile on Arch
