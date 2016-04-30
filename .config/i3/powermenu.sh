#!/bin/bash
 
option=$(echo "         lock|       logout|        sleep|    power off|    shutdown|       restart|     windows" | rofi -sep "|" -dmenu -i -p "" -auto-select -hide-scrollbar -monitor 0 -width 8 -location 3 | xargs)

case $option in
    lock) ./lock.sh;;
    logout) i3-msg exit;;
    sleep) systemctl suspend;;
    shutdown|'power off') systemctl poweroff;;
    restart) systemctl reboot;;
    windows)
        windows=`efibootmgr | grep -Po -m1 'Boot\K(\d{4}).*Windows.*' | head -c4`
        `sudo efibootmgr -n $windows`
        reboot;;
esac

exit 0
