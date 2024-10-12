#!/bin/sh

bar()
{
    case "$1" in
    monitoradded\>\>* | monitorremoved\>\>*)
        eww kill

        monitors=$(hyprctl monitors -j | jq -r '.[] | .name')

        for monitor in $monitors; do
            if [ "$monitor" = "$PRIMARY" ]; then
                eww open primary_bar
                continue
            fi
            if [ -n "$SECONDARY" ] && [ "$monitor" = "$SECONDARY" ]; then
                eww open secondary_bar
                continue
            fi
        done
        ;;
    esac

}

bar "monitoradded>>"

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do
    bar "$line"
done
