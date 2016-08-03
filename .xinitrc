#!/bin/sh

source ~/.profile
source ~/.xsession
xrdb -merge ~/.Xresources

# Run all system xinitrc shell scripts
xinitdir="/etc/X11/xinit/xinitrc.d"
if [ -d "$xinitdir" ]; then
    for script in $xinitdir/*; do
        echo "Loading xinit script $script"
        if [ -x "$script" -a ! -d "$script" ]; then
            . "$script"
        fi
    done
fi

exec i3
