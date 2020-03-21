# Config and cache directory paths
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSH_DIR="$CONFIG_DIR/zsh"
LOG_DIR="$ZSH_DIR/log"
mkdir -p "$LOG_DIR"

HISTFILE="$ZSH_DIR/histfile"
HISTSIZE=999999
SAVEHIST=999999

exists() { which $@ 0<&- 1>/dev/null 2>/dev/null; }

# Only set tty if running interactively
if exists tty && tty -s; then
    # Resolve at shell runtime
    export GPG_TTY="$(tty)"
fi

# Configure less and add colours
export LESS="-RI --mouse"
export PAGER="less"
export MANPAGER="less -+N"
# Disable histfile
export LESSHISTFILE=-

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
setopt sharehistory histignorealldups histignorespace histreduceblanks
setopt pathdirs autocd autopushd extendedglob nullglob alwaystoend interactivecomments dvorak

# Completion initialisation
autoload -U compinit ; compinit
autoload -U bashcompinit ; bashcompinit

# gopass completion
if exists gopass; then
    source <(gopass completion bash)
fi

zstyle ':completion:*:sudo|_::' environ PATH="/sbin:/usr/sbin:$PATH" HOME="/root"
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':compinstall'  filename "${ZDOTDIR:-~}/.zshrc"

# Pre-load vi-mode edit-command-line before antigen plugins are loaded
autoload -z edit-command-line
zle -N edit-command-line

export WORDCHARS='*?_[]~=&;!#$%^(){}'
x-bash-backward-kill-word(){ WORDCHARS='' zle kill-word; }
zle -N x-bash-backward-kill-word

# Load antigen & plugins
ADOTDIR="$ZSH_DIR/antigen" # Antigen directory
ANTIGEN_LOG="$LOG_DIR/antigen-$(date +"%Y_%m_%d_%I_%M_%p").log"
antigen_src="$ADOTDIR/antigen.zsh"
if [ ! -f "$antigen_src" ]; then
    git clone https://github.com/zsh-users/antigen.git "$ADOTDIR"
fi
source "$antigen_src"

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting@feature/redrawhook
antigen bundle mafredri/zsh-async

antigen apply

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
bindkey "^V" edit-command-line
bindkey -M vicmd "^V" edit-command-line
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

default='fg=12'
prog='fg=blue'
ZSH_HIGHLIGHT_STYLES=()
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets root line)
ZSH_HIGHLIGHT_STYLES[root]='bg=red'
ZSH_HIGHLIGHT_STYLES[default]=$default
ZSH_HIGHLIGHT_STYLES[arg0]=$prog
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[alias]=$prog
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=4'
ZSH_HIGHLIGHT_STYLES[function]=$prog
ZSH_HIGHLIGHT_STYLES[command]=$prog
ZSH_HIGHLIGHT_STYLES[precommand]='fg=4'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_separator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=208'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=red'
ZSH_HIGHLIGHT_STYLES[comment]='fg=7'
ZSH_HIGHLIGHT_STYLES[history-expansion]=$default
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=$default
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=$default
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='fg=green'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan,bold'

source "$DOTFILES/aliases"

# Source secret keys and values into environment
if [ -f "$XDG_CONFIG_HOME/secrets" ]; then
    set -o allexport
    source $XDG_CONFIG_HOME/secrets
    set +o allexport
fi

# Load some manual plugins
source "$ZSH_DIR/plugins/sudo.zsh"
source "$ZSH_DIR/plugins/fish-theme.zsh"
source "$ZSH_DIR/plugins/git-rprompt.zsh"
[ -f '/usr/share/fzf/key-bindings.zsh' ] && source /usr/share/fzf/key-bindings.zsh
[ -f '/usr/share/doc/pkgfile/command-not-found.zsh' ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -r '/usr/share/z/z.sh' ] && source /usr/share/z/z.sh
