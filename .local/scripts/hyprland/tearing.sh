#!/bin/sh

STATE="$HOME/.cache/hypr_steam_immediate"

ask()
{
    monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
    tearing=$(hyprctl monitors -j | jq -r '.[] | select(.name == "'"$monitor"'").activelyTearing')

    notify-send "Hyprland" "Monitor $monitor tearing status: $tearing"
}

toggle_steam()
{
    if [ -f "$STATE" ]; then
        hyprctl keyword 'windowrule[steam_immediate]:immediate on'
        rm "$STATE"
        notify-send "Hyprland" "Steam immediate rule enabled"
    else
        hyprctl keyword 'windowrule[steam_immediate]:immediate off'
        touch "$STATE"
        notify-send "Hyprland" "Steam immediate rule disabled"
    fi
}

case "$1" in
ask)
    ask
    ;;
toggle_steam)
    toggle_steam
    ;;
*)
    echo "Usage: $0 [ask|toggle]"
    exit 1
    ;;
esac
