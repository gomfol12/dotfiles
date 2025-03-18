#!/bin/sh

monitor="HDMI-A-1"
tearing=$(hyprctl monitors -j | jq -r '.[] | select(.name == "'"$monitor"'").activelyTearing')

notify-send "Tearing" "Monitor $monitor tearing status: $tearing"
