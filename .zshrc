unsetopt MULTIBYTE

# Path to your oh-my-zsh installation.
ZSH=$HOME/.local/share/oh-my-zsh

# Set the theme
ZSH_THEME="fishy"
#DISABLE_AUTO_UPDATE="true"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSH_CONFIG_DIR=$CONFIG_DIR/zsh
ZSH_CACHE_DIR=$CONFIG_DIR/oh-my-zsh/cache
mkdir -p $ZSH_CACHE_DIR $ZSH_CONFIG_DIR

HISTFILE=$ZSH_CONFIG_DIR/histfile
HISTSIZE=100000
SAVEHIST=100000
setopt sharehistory histignoredups histignorespace histreduceblanks autocd autopushd extendedglob alwaystoend dvorak

# Only set tty if running interactively
if tty -s; then
    # Resolve at shell runtime
    export GPG_TTY="$(tty)"
fi

export WORDCHARS='*?_[]~=&;!#$%^(){}'

bindkey -e
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line

x-bash-backward-kill-word(){
    WORDCHARS='' zle kill-word
}
zle -N x-bash-backward-kill-word
bindkey '^[^[[3~' x-bash-backward-kill-word
bindkey '^[^[[3^' x-bash-backward-kill-word

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey "^[^[[B" down-line-or-beginning-search # Down

zstyle ':completion:*:sudo::' environ PATH="/sbin:/usr/sbin:$PATH" HOME="/root"
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle :compinstall filename "$HOME/.zshrc"

autoload -U compinit ; compinit

plugins=(command-not-found history-substring-search sudo zsh-autosuggestions zsh-completions)
source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)

setopt HIST_IGNORE_ALL_DUPS
ZSH_HIGHLIGHT_STYLES[default]='fg=blue'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[alias]='fg=63'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=63'
ZSH_HIGHLIGHT_STYLES[function]='fg=63'
ZSH_HIGHLIGHT_STYLES[command]='fg=63'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=63'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=blue'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=63,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=red,bold,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=red'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=blue'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=blue'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='none'
ZSH_HIGHLIGHT_STYLES[redirection]='none'

source $DOTFILES/aliases

# OPAM configuration
. /home/frebib/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
