export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_NUMERIC=en_GB

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_CURRENT_DESKTOP="GNOME" # Fixes xdg-open

case "$(basename "$(readlink -f /proc/$$/exe)")" in
    zsh)  thisfile="$(readlink -f "${(%):-%N}")";;
    bash) thisfile="$(readlink -f "${BASH_SOURCE[0]}")";;
    *)   thisfile="$(find /proc/$$/fd/ | xargs readlink -f | grep .profile | head -n1)";;
esac
export DOTFILES="$(dirname "${thisfile:-$XDG_CONFIG_HOME/dotfiles}")"
export PATH="${PATH}:$DOTFILES/scripts"

# Allow Vim to load from ~/.config/vim
export VIMDIR="$XDG_CONFIG_HOME/vim"
export MYVIMRC="$VIMDIR/vimrc"
export VIMINIT=":so $MYVIMRC"
export EDITOR="vim"
export VISUAL="vim"

# Allow ZSH to load from ~/.config/zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Configure X11 config file paths
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSESSION="$XDG_CONFIG_HOME/X11/xsession"

export MANPAGER="less -+N"
export TERMINAL="termite"
export BROWSER="chromium"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export QT_QPA_PLATFORMTHEME=gtk2
export GOPATH="$XDG_LOCAL_HOME/go"

exists() { which $@ 0<&- 1>/dev/null 2>/dev/null; }

export LESS="-RI"
export PAGER="less $LESS"
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

# Merge system clipboards
if [ -n "$DISPLAY" ] && exists autocutsel && ! pidof autocutsel 1>/dev/null; then
    autocutsel -fork
    autocutsel -selection PRIMARY -fork
fi

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && exists dbus-launch; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
    dbus-update-activation-environment --systemd DISPLAY
fi

# Start the gnome-keyring if it's installed
if exists gnome-keyring-daemon; then
    export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
fi
