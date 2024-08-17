#!/bin/sh
# TODO: click action on notification to open screenshot with sxiv

pacman_dep_check()
{
    pacman -Q "$1" >/dev/null 2>&1 || {
        echo "$1 is not installed"
        exit 1
    }
}

if [ -n "$WAYLAND_DISPLAY" ]; then
    pacman_dep_check "grim"
    pacman_dep_check "slurp"
    pacman_dep_check "wl-clipboard"
else
    pacman_dep_check "maim"
    pacman_dep_check "xdotool"
    pacman_dep_check "xclip"
fi

notify()
{
    notify-send "Maim" "Screenshot Taken"
    exit
}

output=~/doc/bilder/screenshots

if [ ! -d $output ]; then
    mkdir -p $output
fi

output=$output/"$(date +%s_%d.%m.%Y-%H-%M).png"

action=$(printf "select\nclipselect\nfull\nactive\nclipactive\nselectclippath" | dmenu -p "Screenshotter:")

case $action in
"full")
    if [ -n "$WAYLAND_DISPLAY" ]; then
        grim "$output"
    else
        maim "$output"
    fi
    notify
    ;;
"select")
    if [ -n "$WAYLAND_DISPLAY" ]; then
        slurp | grim -g - "$output"
    else
        maim -s "$output"
    fi
    notify
    ;;
"clipselect")
    if [ -n "$WAYLAND_DISPLAY" ]; then
        slurp | grim -g - - | wl-copy --type image/png
    else
        maim -s | xclip -selection clipboard -t image/png
    fi
    notify
    ;;
"selectclippath")
    if [ -n "$WAYLAND_DISPLAY" ]; then
        slurp | grim -g - "$output"
        echo "$output" | wl-copy --type text/plain
    else
        maim -s "$output"
        echo "$output" | xclip -selection clipboard
    fi
    notify
    ;;
"active")
    if [ -n "$WAYLAND_DISPLAY" ]; then
        notify-send "Error" "Active window screenshot not supported on Wayland"
        exit 1
    else
        maim -i "$(xdotool getactivewindow)" "$output"
    fi
    notify
    ;;
"clipactive")
    if [ -n "$WAYLAND_DISPLAY" ]; then
        notify-send "Error" "Active window screenshot not supported on Wayland"
        exit 1
    else
        maim -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png
    fi
    notify
    ;;
esac
