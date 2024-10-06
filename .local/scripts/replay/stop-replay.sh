#!/bin/sh

killall -SIGINT gpu-screen-recorder && notify-send -t 1500 -u low -- "GPU Screen Recorder" "Replay stopped"
