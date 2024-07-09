#!/bin/bash

title="Wallpaper Changed"
bg_path="${XDG_DATA_HOME:-$HOME/.local/share/}/bg"

if [ -f "$1" ]; then
    ln -sf "$(readlink -f "$1")" "$bg_path"
    notify-send -i "$bg_path" "$title" "Changing theme..."

    # generate theme
    theming -i "$bg_path" -r

    # xsettingsd restart
    if [ "$(pgrep -u "$(id -u)" -nf "xsettingsd")" ]; then
        killall xsettingsd
    fi
    if [ "$(hostname)" = "$HOSTNAME_LAPTOP" ]; then
        xsettingsd --config ~/.config/xsettingsd/xsettingsd-laptop.conf >/dev/null 2>&1 &
    else
        xsettingsd >/dev/null 2>&1 &
    fi

    sleep 2 # wait for awesome to restart
    notify-send -i "$bg_path" "$title" "theme changed"
else
    theming -r
fi
