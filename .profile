export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_NUMERIC=en_GB

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_LOCAL_HOME="$HOME/.local"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_LOCAL_HOME"

case "$(basename "$(readlink -f /proc/$$/exe)")" in
    zsh)  thisfile="$(readlink -f "${(%):-%N}")";;
    bash) thisfile="$(readlink -f "${BASH_SOURCE[0]}")";;
    *)   thisfile="$(find /proc/$$/fd/ | xargs -n1 -r readlink -f | grep profile | head -n1)";;
esac

export EDITOR="vim"
export VISUAL="vim"

# Override paths for non-compliant programs
# https://wiki.archlinux.org/index.php/XDG_Base_Directory_support

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/settings.ini"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PYTHONHISTFILE="$XDG_DATA_HOME/python/histfile"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export VIMDIR="$XDG_CONFIG_HOME/vim"
export VIMRC="$VIMDIR/vimrc"
export VIMINIT=":so $VIMRC"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export DOTFILES="$(dirname "${thisfile:-$XDG_CONFIG_HOME/dotfiles/.profile}")"
export PATH="${PATH}:/sbin:/usr/sbin:$DOTFILES/scripts:$GOPATH/bin"

exists() { which $@ 0<&- 1>/dev/null 2>/dev/null; }

# Configure less and add colours
export LESS="-RI"
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

# Source secret keys and values into environment
if [ -f "$XDG_CONFIG_HOME/secrets" ]; then
    set -o allexport
    source $XDG_CONFIG_HOME/secrets
    set +o allexport
fi

# Start a dbus session daemon for programs that require it
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && exists dbus-launch; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
    dbus-update-activation-environment --systemd \
        DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
fi

