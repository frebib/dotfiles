#!/bin/sh
set -e

# Use the provided interface, otherwise the device used for the default route.
if [[ -n $BLOCK_INSTANCE ]]; then
    IF=$BLOCK_INSTANCE
else
    IF=$(ip route | awk '/^default/ { print $5 ; exit }')
fi

[ -e /sys/class/net/${IF} ] || exit

if [ -z "$IF" ] || [ "$(cat /sys/class/net/$IF/operstate)" = 'down' ]; then
    echo down
    echo \#FF0000 # color
    exit
fi

case $1 in
    -4) AF=inet ;;
    -6) AF=inet6 ;;
    *) AF=inet6? ;;
esac

# if no interface is found, use the first device with a global scope
ip addr show $IF | sed -nE "s/.*$AF ([^\\/]+).* scope global.*/\\1/p"


# case $BLOCK_BUTTON in
#     1)  curl -s https://api.ipify.org;
#         break;;
#     2)  curl -s https://api.ipify.org | tee >(xclip -i);
#         break;;
#     0|3)  echo "$LOCIP" | tee >(xclip -i);
#         break;;
# esac

