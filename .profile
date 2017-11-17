export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_NUMERIC=en_GB

export CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
export DOTFILES=$CONFIG_DIR/dotfiles
export PATH="${PATH}:$DOTFILES/scripts"
export XDG_CURRENT_DESKTOP="GNOME" # Fixes xdg-open

export EDITOR="vim"
export VISUAL="vim"
export LESS="-RNI"
export PAGER="less $LESS"
export TERMINAL="termite"
export BROWSER="chromium"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export QT_QPA_PLATFORMTHEME=gtk2

# Source secret keys and values into environment
if [ -f "$CONFIG_DIR/secrets" ]; then
    set -o allexport
    source $CONFIG_DIR/secrets
    set +o allexport
fi

# Merge system clipboards
if [ -n "$DISPLAY" ] && which autocutsel &>/dev/null; then
    autocutsel -fork
    autocutsel -selection PRIMARY -fork
fi

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
    dbus-update-activation-environment --systemd DISPLAY
fi

# Start the gnome-keyring if it's installed
if which gnome-keyring-daemon &>/dev/null; then
    export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
fi
