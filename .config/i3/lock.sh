#!/usr/bin/env bash

icon="$HOME/.config/i3/lock.png"
tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

# screenshot
scrot "$tmpbg"

PX=0
PY=0
# lockscreen image info
R=$(file $icon | grep -o '[0-9]* x [0-9]*')
RX=$(echo $R | cut -d' ' -f 1)
RY=$(echo $R | cut -d' ' -f 3)

RES=$(xrandr --query | grep ' connected primary' | cut -f4 -d' ')

# monitor position/offset
SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
PX=$(($SROX + $SRX/2 - $RX/2))
PY=$(($SROY + $SRY/2 - $RY/2))


# pixelize and add lock icon
convert $tmpbg -scale 5% -scale 2000% $tmpbg
convert $tmpbg $icon -geometry +$PX+$PY -composite -matte $tmpbg

playing=$(mpc status | grep playing | wc -l)
[[ $playing == 1 ]] && mpc pause

i3lock -i "$tmpbg" -n -e

[[ $playing == 1 ]] && mpc play


rm "$tmpbg"
