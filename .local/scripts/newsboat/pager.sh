#!/bin/bash

draw()
{
    "$SCRIPT_DIR/newsboat/draw_img.sh" "$@"
}

hash()
{
    printf '%s/.cache/newsboat_img/%s' "$HOME" \
        "$(echo "$1" | sha256sum | awk '{print $1}')"
}

dont_draw=false

lines=$(tput lines)
cols=$(($(tput cols) - 4))
line_count=$(($(cat "$1" | wc -l)))

if [ "$cols" -gt 80 ]; then
    cols=80
fi

img_x=2
img_width=$cols
img_height=$(("$lines" - "$line_count" - 2))
img_y=$line_count

if [ "$img_height" -le 10 ]; then
    dont_draw=true
fi

while read -r line; do
    if [ "$dont_draw" == false ]; then
        if [[ "$line" =~ ^\[.*\]:\ https:\/\/i\.redd\.it\/ ]] || [[ "$line" =~ ^\[.*\]:\ https:\/\/i\.imgur\.com\/ ]]; then
            url=$(echo "$line" | cut -d" " -f2)

            if [ -n "$url" ]; then
                cache="$(hash "$url")"
                if [ -f "$cache" ]; then
                    draw "$img_x" "$img_y" "$img_width" "$img_height" "$cache"
                else
                    curl -sL "$url" >"$cache"
                    draw "$img_x" "$img_y" "$img_width" "$img_height" "$cache"
                fi
            fi
        fi
        if [[ "$line" =~ ^Link:\ https:\/\/www.youtube.com\/watch\?v= ]]; then
            url=$(echo "$line" | cut -d" " -f2)

            if [ -n "$url" ]; then
                cache="$(hash "$url")"
                if [ -f "$cache" ]; then
                    draw "$img_x" "$img_y" "$img_width" "$img_height" "$cache"
                else
                    curl -sL "$(youtube-dl --get-thumbnail "$url")" >"$cache"
                    draw "$img_x" "$img_y" "$img_width" "$img_height" "$cache"
                fi
            fi
        fi
    fi
done <"$1" 1>/dev/null &

if [ "$dont_draw" == false ]; then
    less "$1" && "$SCRIPT_DIR/newsboat/clear_img.sh"
else
    less "$1"
fi
