#!/bin/bash
 
option=$(echo "         lock|       logout|        sleep|    shutdown|       restart" | rofi -sep "|" -dmenu -i -p "" -auto-select -hide-scrollbar -monitor 0 -width 8 -location 3 | xargs)

case $option in
    lock) ./lock.sh;;
    logout) i3-msg exit;;
    restart) reboot;;
    sleep) systemctl suspend;;
    shutdown) poweroff;;
esac

exit 0
