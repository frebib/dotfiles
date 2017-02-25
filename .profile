export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_NUMERIC=en_GB

export CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
export DOTFILES=$CONFIG_DIR/dotfiles
export PATH="${PATH}:$DOTFILES/scripts"
export XDG_CURRENT_DESKTOP="GNOME" # Fixes xdg-open

export EDITOR="vim"
export VISUAL="vim"
export PAGER="less -R"
export TERMINAL="termite"
export BROWSER="chromium"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export QT_STYLE_OVERRIDE=GTK+
export QT_QPA_PLATFORMTHEME=gtk2

# Merge system clipboards
if ! [ -z $DISPLAY ] && which autocutsel &>/dev/null; then
    autocutsel -fork &
    autocutsel -selection PRIMARY -fork &
fi

# Start an ssh-agent
if [ -z $SSH_AUTH_SOCK ]; then
    eval `ssh-agent`
fi
# Always add SSH key to the running agent; local or remote
ssh-add
