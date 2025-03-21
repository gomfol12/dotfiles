#!/bin/sh

title()
{
    case $1 in
    activewindow\>\>* | windowtitle\>\>* | movewindow\>\>*)
        shift

        active_workspace=$(hyprctl monitors -j | jq '.[] | select(.name == "'"$1"'").activeWorkspace.id')
        focused=$(hyprctl monitors -j | jq -r '.[] | select(.name == "'"$1"'").focused')
        title=$(hyprctl workspaces -j | jq -r '.[] | select(.id == '"$active_workspace"').lastwindowtitle' | sed 's/"/\\"/g' | tr '\n' ' ')

        if [ "$focused" = "true" ]; then
            echo "(box :class \"title_focused\" :orientation \"h\" :space-evenly false :halign \"fill\" :hexpand true :vexpand true \
                    (label :text \"$title\") \
                  )"
        else
            echo "(box :class \"title\" :orientation \"h\" :space-evenly false :halign \"fill\" :hexpand true :vexpand true \
                    (label :text \"$title\") \
                  )"
        fi
        ;;
    esac
}

title "activewindow>>" "$1"

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do
    title "$line" "$1"
done
