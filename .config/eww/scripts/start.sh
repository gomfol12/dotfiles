#!/bin/sh

bar()
{
    case "$1" in
    monitoradded\>\>* | monitorremoved\>\>*)
        eww kill

        monitors=$(hyprctl monitors -j | jq -r '.[] | .name')

        for monitor in $monitors; do
            if [ "$monitor" = "HDMI-A-1" ]; then
                eww open primary_bar
                continue
            fi
            if [ "$monitor" = "DVI-D-1" ]; then
                eww open secondary_bar
                continue
            fi
            eww open secondary_bar
        done
        ;;
    esac

}

bar "monitoradded>>"

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do
    bar "$line"
done
