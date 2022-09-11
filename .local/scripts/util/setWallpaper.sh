#!/bin/bash

title="Wallpaper Changed"
bg_path="${XDG_DATA_HOME:-$HOME/.local/share/}/bg"
backend="wal"

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
[ -z "$1" ] || {
    sleep 1 && notify-send -i "$bg_path" "$title" "theme changed"
} &
