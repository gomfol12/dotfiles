#!/bin/bash

if ! [ "$(hostname)" = "$HOSTNAME_LAPTOP" ]; then
    echo "This script is only for $HOSTNAME_LAPTOP"
    exit
fi

pacman_dep_check()
{
    pacman -Q "$1" >/dev/null 2>&1 || {
        echo "$1 is not installed"
        exit 1
    }
}
pacman_dep_check "brillo"

case $1 in
up)
    brillo -q -u 150000 -A 5
    ;;
down)
    brillo -q -u 150000 -U 5
    ;;
sup)
    brillo -q -u 150000 -A 1
    ;;
sdown)
    brillo -q -u 150000 -U 1
    ;;
*)
    echo "Usage: $(basename "$0") [up|down|sup|sdown]"
    ;;
esac
