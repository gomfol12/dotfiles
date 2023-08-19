#!/bin/sh
# TODO: click action on notification to open screenshot with sxiv

notifyOpen()
{
    notify-send "Maim" "Screenshot Taken"
    exit
}

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

action=$(printf "select\nfull\nactive\nclipactive\nselectclippath" | dmenu -p "Screenshotter:")

case $action in
"full") maim "$output" && notifyOpen ;;
"select") maim -s "$output" && notifyOpen ;;
"selectclippath")
    maim -s "$output"
    echo "$output" | xclip -selection clipboard
    notifyOpen
    ;;
"active") maim -i "$(xdotool getactivewindow)" "$output" && notifyOpen ;;
"clipactive") maim -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png && notify ;;
esac
