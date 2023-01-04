#!/bin/bash

url=$1

hash()
{
    printf '%s/.cache/newsboat_img/%s' "$HOME" \
        "$(echo "$1" | sha256sum | awk '{print $1}')"
}

case $url in
*mkv | *webm | *youtube.com/watch* | *youtube.com/playlist* | *youtube.com/shorts* | *youtu.be* | *v.redd.it*) setsid -f mpv -quiet "$url" >/dev/null 2>&1 ;;
*png | *jpg | *jpeg | *gif)
    cache="$(hash "$url")"
    if [ ! -f "$cache" ]; then
        curl -sL "$url" >"$cache"
    fi
    setsid -f sxiv.sh "$cache" >/dev/null 2>&1
    ;;
*) $BROWSER "$url" ;;
esac
