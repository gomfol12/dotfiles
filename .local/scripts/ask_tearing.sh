#!/bin/sh

monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
tearing=$(hyprctl monitors -j | jq -r '.[] | select(.name == "'"$monitor"'").activelyTearing')

notify-send "Tearing" "Monitor $monitor tearing status: $tearing"
