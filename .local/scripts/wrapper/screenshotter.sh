#!/bin/sh

notify()
{
    notify-send "Maim" "Screenshot Taken"
}

output=~/doc/bilder/screenshots

if [ ! -d $output ]; then
    mkdir -p $output
fi

output=$output/"$(date +%s_%d.%m.%Y-%H-%M).png"

action=$(printf "full\nselect\nactive\nclipactive" | dmenu -p "Screenshotter:")

case $action in
"full") maim "$output" && notify || exit ;;
"select") maim -s "$output" && notify || exit ;;
"active") maim -i "$(xdotool getactivewindow)" "$output" && notify || exit ;;
"clipactive") maim -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png && notify || exit ;;
esac
