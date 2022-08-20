#!/bin/sh

configfile=$HOME/.config/bg-saved.png

awesome_set_wallpaper()
{
    awesome-client '
            local wallpaper = require("appearance.wallpaper")
            for s in screen do
                wallpaper.set_wallpaper(s)
            end
'
}

if [ "$#" -eq 1 ]; then
    cp "$1" "$configfile" &&
        awesome_set_wallpaper
elif [ "$#" -eq 0 ]; then
    if [ -f "$configfile" ]; then
        awesome_set_wallpaper
    fi
else
    printf "Invalid argument"
fi

#wal -n -e -s -i "$1" -o "reload_env.sh" &&
#wal -n -e -s -R
