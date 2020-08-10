#!/bin/sh

dothething() { count=$( (checkupdates & yay -Qum) 2>/dev/null | wc -l); test $count -gt 0 && echo $count || echo; }

trap 'true' HUP USR1

while true; do
    dothething
    sleep 120 &
    wait
done
