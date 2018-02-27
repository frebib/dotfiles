export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_NUMERIC=en_GB

export CONFIG_DIR="$HOME/.config"
export XDG_CONFIG_HOME="$CONFIG_DIR"
export DOTFILES="$CONFIG_DIR/dotfiles"
export PATH="${PATH}:$DOTFILES/scripts"
export XDG_CURRENT_DESKTOP="GNOME" # Fixes xdg-open

# Allow Vim to load from ~/.config/vim
export VIMDIR="$CONFIG_DIR/vim"
export MYVIMRC="$VIMDIR/vimrc"
export VIMINIT=":so $MYVIMRC"

export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="less -+N"
export TERMINAL="termite"
export BROWSER="chromium"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export QT_QPA_PLATFORMTHEME=gtk2

export LESS="-RNI"
export PAGER="less $LESS"
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

# Source secret keys and values into environment
if [ -f "$CONFIG_DIR/secrets" ]; then
    set -o allexport
    source $CONFIG_DIR/secrets
    set +o allexport
fi

# Merge system clipboards
if [ -n "$DISPLAY" ] && which autocutsel >/dev/null 2>&1; then
    autocutsel -fork
    autocutsel -selection PRIMARY -fork
fi

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && which dbus-launch >/dev/null 2>&1; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
    dbus-update-activation-environment --systemd DISPLAY
fi

# Start the gnome-keyring if it's installed
if which gnome-keyring-daemon >/dev/null 2>&1; then
    export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
fi
