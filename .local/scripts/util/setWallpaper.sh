#!/bin/sh
#TODO: add an icon in the notification

configfile=$HOME/.config/bg-saved.png

if [ "$#" -eq 1 ]; then
    cp "$1" "$configfile" &&
        feh --no-fehbg --bg-fill "$configfile" &&
        notify-send "Wallpaper changed"
elif [ "$#" -eq 0 ]; then
    if [ -f "$configfile" ]; then
        feh --no-fehbg --bg-fill "$configfile"
    fi
else
    printf "Invalid argument"
fi

#wal -n -e -s -i "$1" -o "reload_env.sh" &&
#wal -n -e -s -R
