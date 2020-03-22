#!/bin/sh
 
option=$(echo "lock|logout|sleep|hibernate|power off|reboot|windows" | rofi -sep "|" -dmenu -i -p "" -auto-select -hide-scrollbar -monitor 0 -width 10 -lines 7 -location 3 -tokenize false -matching normal | xargs)

case $option in
    lock) dm-tool switch-to-greeter;;
    logout) i3-msg exit;;
    sleep) systemctl suspend;;
    hibernate) systemctl hibernate;;
    power\ off) systemctl poweroff;;
    reboot) systemctl reboot;;
    windows)
        windows=`efibootmgr | grep -Po -m1 'Boot\K(\d{4}).*Windows.*' | head -c4`
        sudo efibootmgr -n $windows
        reboot;;
esac

exit 0
