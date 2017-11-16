unsetopt MULTIBYTE

# Config and cache directory paths
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSH_DIR="$CONFIG_DIR/zsh"
ZSH_CACHE_DIR="$CONFIG_DIR/oh-my-zsh/cache"
ADOTDIR="$ZSH_DIR/antigen" # Antigen directory
ANTIGEN_LOG="$ADOTDIR/log/antigen-$(date +"%Y_%m_%d_%I_%M_%p").log"

mkdir -p "$ZSH_CACHE_DIR" "$ZSH_DIR" "$ADOTDIR/log"

HISTFILE="$ZSH_DIR/histfile"
HISTSIZE=999999
SAVEHIST=999999

# Only set tty if running interactively
if tty -s; then
    # Resolve at shell runtime
    export GPG_TTY="$(tty)"
fi

# Set some useful ZSH/Bash options
setopt sharehistory histignorealldups histignorespace histreduceblanks
setopt pathdirs autocd autopushd extendedglob alwaystoend dvorak


# Completion initialisation
autoload -U compinit ; compinit
autoload -U bashcompinit ; bashcompinit

# gopass completion
if gopass --help &>/dev/null; then
    source <(gopass completion bash)
fi

zstyle ':completion:*:sudo|_::' environ PATH="/sbin:/usr/sbin:$PATH" HOME="/root"
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':compinstall'  filename "$HOME/.zshrc"


# Load antigen & plugins
antigen_src="$ZSH_DIR/antigen.zsh"
if [ ! -f "$antigen_src" ]; then
    if which curl &>/dev/null; then
        getcmd='curl -L'
    else
        getcmd='wget -qO-'
    fi
    eval $getcmd git.io/antigen > "$antigen_src"
fi
source "$antigen_src"

antigen bundle sudo
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle Tarrasch/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

antigen apply


# Set some key-binds
bindkey -e
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line

export WORDCHARS='*?_[]~=&;!#$%^(){}'
x-bash-backward-kill-word(){
    WORDCHARS='' zle kill-word
}
zle -N x-bash-backward-kill-word
bindkey '^[^[[3~' x-bash-backward-kill-word
bindkey '^[^[[3^' x-bash-backward-kill-word

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)

HISTORY_SUBSTRING_SEARCH_FUZZY=true
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=12'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command]='fg=blue'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=blue'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=red'
ZSH_HIGHLIGHT_STYLES[comment]='fg=7'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=12'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=12'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='fg=green'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'

source "$ZSH_DIR/fish-theme.zsh"
source "$DOTFILES/aliases"
