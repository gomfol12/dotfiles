#!/bin/sh
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar HDMI-0 &
polybar DVI-D-0 &
