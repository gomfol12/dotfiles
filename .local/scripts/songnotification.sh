#!/bin/sh
cacheDir="$HOME/.cache/songnotification"
player="mopidy"

if [ ! -d "$cacheDir" ]; then
	mkdir -p "$cacheDir"
fi

imgUrl=$(playerctl --player $player metadata -f "{{mpris:artUrl}}")
filename=$(basename "$imgUrl")

title=$(playerctl --player $player metadata -f "{{xesam:title}}")
artistAlbum=$(playerctl --player $player metadata -f "{{xesam:artist}} - {{xesam:album}}")

if [ -n "$filename" ]; then
    if [ ! -f "$cacheDir/$filename" ]; then
	    curl -s "$imgUrl" > "$cacheDir/$filename"
    fi
    notify-send --icon "$cacheDir/$filename" "$title" "$artistAlbum"
else
    notify-send "$title" "$artistAlbum"
fi
