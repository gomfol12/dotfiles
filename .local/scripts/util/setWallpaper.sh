#!/bin/bash

title="Wallpaper Changed"
bg_path="${XDG_DATA_HOME:-$HOME/.local/share/}/bg"
backend="wal"

theme_name="oomox-xresources-reverse"
icon_theme_name="oomox-xresources-reverse-flat"

[ -f "$1" ] && ln -sf "$(readlink -f "$1")" "$bg_path" && notification="Changing theme..."

wal --backend "${backend:-wal}" -n -s -i "$(readlink -f "$bg_path")" >/dev/null 2>&1
[ -z "$1" ] || awesome-client 'awesome.restart()' >/dev/null 2>&1
[ -z "$1" ] || {
    sleep 1 && notify-send -i "$bg_path" "$title" "$notification"
} &
[ -z "$1" ] || chameleon.py -i "$(readlink -f "$bg_path")" --backend "${backend:-wal}" -n -s >/dev/null 2>&1
[ -z "$1" ] || {
    if [ "$(pgrep -u "$(id -u)" -nf "xsettingsd")" ]; then
        killall xsettingsd
    fi
    xsettingsd >/dev/null 2>&1 &
}
pidof st | xargs -r kill -SIGUSR1 >/dev/null 2>&1
[ -z "$1" ] || pywalfox update

if [ -d "$HOME/.themes/$theme_name" ]; then
    if [ ! -d "$HOME/.local/share/themes/" ]; then
        mkdir -p "$HOME/.local/share/themes/"
    fi
    cp -rf "$HOME/.themes/$theme_name" "$HOME/.local/share/themes/"
    rm -rf "$HOME/.themes"
fi
if [ -d "$HOME/.icons/$icon_theme_name" ]; then
    if [ ! -d "$HOME/.local/share/icons/" ]; then
        mkdir -p "$HOME/.local/share/icons/"
    fi
    cp -rf "$HOME/.icons/$icon_theme_name" "$HOME/.local/share/icons/"
    rm -rf "$HOME/.icons/$icon_theme_name"
fi

[ -z "$1" ] || {
    sleep 1 && notify-send -i "$bg_path" "$title" "theme changed"
} &
