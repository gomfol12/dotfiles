#!/bin/sh

pidof -q gpu-screen-recorder && exit 0
video_path="$HOME/doc/bilder/replay"
mkdir -p "$video_path"
gpu-screen-recorder -w portal -f 60 -a default_output -c mkv -r 30 -o "$video_path"
