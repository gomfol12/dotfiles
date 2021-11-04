#!/bin/sh
tmpDir=/tmp/songnotification

if [ ! -d $tmpDir ]; then
	mkdir -p $tmpDir
fi

data=$(playerctl --player spotifyd metadata -f "{{mpris:artUrl}}\n{{title}}\n{{artist}}\n{{album}}")

while [ "$data" = "No player could handle this command" ]; do
    data=$(playerctl --player spotifyd metadata -f "{{mpris:artUrl}}\n{{title}}\n{{artist}}\n{{album}}")
    sleep 1
done

imgurl=$(printf "%b\n" "$data" | head -1)
filename=${imgurl##*/}

if [ ! -e "$tmpDir/$filename" ]; then
	curl "$imgurl" > /tmp/songnotification/"$filename"
fi

notify-send "$(printf "%b\n" "$data" | head -2 | tail -1)" "$(printf "%b\n" "$data" | tail -2 | sed 'N;s/\n/ - /')" --icon=/tmp/songnotification/"$filename"
