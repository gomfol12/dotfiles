#!/bin/sh

urgentworkspace=""

workspaces()
{
    case $1 in
    workspace\>\>* | movewindow\>\>* | openwindow\>\>* | closewindow\>\>*)
        shift

        box="(box :class \"workspaces\" :orientation \"h\" :halign \"start\" "

        focused=$(hyprctl monitors -j | jq '.[] | select(.name == "'"$1"'").activeWorkspace.id')

        for i in $(hyprctl workspaces -j | jq '.[] | select(.monitor == "'"$1"'").id'); do
            if [ "$i" = "$focused" ]; then
                box="${box} (button :onclick \"hyprctl dispatch workspace $i\" :class \"focused\""
                if [ "$focused" = "$urgentworkspace" ]; then
                    urgentworkspace=""
                fi
            elif [ "$i" = "$urgentworkspace" ]; then
                box="${box} (button :onclick \"hyprctl dispatch workspace $i\" :class \"urgent\""
            else
                box="${box} (button :onclick \"hyprctl dispatch workspace $i\""
            fi

            occupied=$(hyprctl workspaces -j | jq '.[] | select(.monitor == "'"$1"'" and .id == '"$i"').windows')
            if [ "$occupied" -gt 0 ]; then
                box="${box} (box \
                                 (box :class \"button_occupied\" \
                                   (label :text \"$i\") \
                                 ) \
                                 (box :class \"occupied\" :orientation \"v\" :valign \"start\" :halign \"end\") \
                            ) \
                            )"
            else
                box="${box} (box :class \"button_normal\" :orientation \"h\" :halign \"center\" \
                                   (label :text \"$i\") \
                            ) \
                            )"
            fi
        done

        echo "${box} )"
        ;;
    urgent\>\>*)
        address=$(echo "$1" | cut -d'>' -f3)
        urgentworkspace=$(hyprctl clients -j | jq '.[] | select(.address == "'"0x$address"'").workspace.id')

        workspaces "workspace>>" "$2"
        ;;
    esac
}

workspaces "workspace>>" "$1"

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do
    workspaces "$line" "$1"
done
