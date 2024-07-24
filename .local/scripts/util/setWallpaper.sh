#!/bin/bash

# small floating terminal as password prompt. Don't forget to set according rule in your window manager
exec_term()
{
    ${TERMINAL:-st} -n floatterm -g 60x2 -e "$@"
}

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
    xsettingsd >/dev/null 2>&1 &

    exec_term sh -ci "echo Update sddm theme && sudo sddm_setup.sh \"$bg_path\""

    notify-send -i "$bg_path" "$title" "theme changed"
elif [ -d "$1" ]; then
    notify-send "Error" "Directory, not a file"
else
    theming -r

    if [ "$DESKTOP_SESSION" = "hyprland" ]; then
        swww img "$bg_path" --transition-type wipe
    fi
fi
