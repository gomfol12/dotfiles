#!/bin/sh
#TODO: add an icon in the notification

configfile=$HOME/.config/bg-saved.png

if [ "$#" -eq 1 ]; then
    cp "$1" "$configfile" &&
    feh --no-fehbg --bg-scale "$configfile" &&
    notify-send "Wallpaper changed"
elif [ "$#" -eq 0 ]; then
    if [ -f "$configfile" ]; then
        feh --no-fehbg --bg-scale "$configfile"
    fi
else
    printf "Invalid argument"
fi
