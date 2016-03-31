#!/bin/sh

xrdb -merge ~/.Xresources

# start some programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

setxkbmap -option caps:none
xset r rate 180 24
xbindkeys &

xrandr --dpi 96

pulseaudio &
dropbox &

exec i3
