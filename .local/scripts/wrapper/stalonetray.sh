#!/bin/sh
pidof stalonetray 1>/dev/null && killall stalonetray || stalonetray --config ~/.config/stalonetray/stalonetrayrc &
