#!/bin/bash

url=$1

case $url in
*mkv | *webm | *youtube.com/watch* | *youtube.com/playlist* | *youtube.com/shorts* | *youtu.be* | *v.redd.it*) setsid -f mpv -quiet "$url" >/dev/null 2>&1 ;;
*png | *jpg | *jpeg | *gif)
    file=$(echo "$url" | sed "s/.*\///;s/%20/ /g")
    if [ ! -f "$file" ]; then
        curl -sL "$url" >"/tmp/$file"
    fi
    setsid -f sxiv.sh "/tmp/$file" >/dev/null 2>&1
    ;;
*) $BROWSER "$url" ;;
esac
