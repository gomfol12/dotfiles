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

highlight=$(sed 's/\(http[s]*:\/\/[^ ]*\)/\\033[32m\1\\033[0m/g;
s/\(^Title:.*$\)/\\033[34;1m\1\\033[0m/g;
s/\(^Feed:.*$\)/\\033[36m\1\\033[0m/g;
s/\(^Author:.*$\)/\\033[36m\1\\033[0m/g;
s/\(\[[0-9][0-9]*\]\)/\\033[35m\1\\033[0m/g' "$1")

lesskey=$(mktemp)
echo "#command" >> "$lesskey"
grep -o '\[[0-9]\]: https://[^ ]*' "$1" | sed -u 's/\[\([0-9]\)\]: \(.*\)/\1 shell $BROWSER "\2" \&\& xdotool key Return\\n/' >> "$lesskey"
grep -o 'Link: https://[^ ]*' "$1" | sed -u 's/Link: \(.*\)/o shell $BROWSER "\1" \&\& xdotool key Return\\n/' >> "$lesskey"

# shellcheck disable=2034
LESS="-irsMR +Gg"
if [ "$dont_draw" == false ]; then
    # less "$1" && "$SCRIPT_DIR/newsboat/clear_img.sh"
    echo -e "$highlight" | less --lesskey-src="$lesskey" && "$SCRIPT_DIR/newsboat/clear_img.sh"
else
    echo -e "$highlight" | less --lesskey-src="$lesskey"
fi
