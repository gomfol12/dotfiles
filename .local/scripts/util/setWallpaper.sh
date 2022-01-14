#!/bin/sh
#TODO: add an icon in the notification

configfile=$HOME/.config/bg-saved.png

if [ "$#" -eq 1 ]; then
    cp "$1" "$configfile" &&
    feh --no-fehbg --bg-fill "$configfile" &&
    wal -n -e -s -i "$1" --saturate 0.5 -o "reload_env.sh" &&
    notify-send "Wallpaper changed"
elif [ "$#" -eq 0 ]; then
    if [ -f "$configfile" ]; then
        feh --no-fehbg --bg-fill "$configfile" &&
        wal -n -e -s -R
    fi
else
    printf "Invalid argument"
fi
