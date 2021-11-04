#!/bin/sh

if [ ! $(pgrep "picom") ]; then
	picom &
	notify-send "Picom started"
else
	killall picom
	notify-send "Picom killed"
fi
