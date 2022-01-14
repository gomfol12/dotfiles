#!/bin/sh

if [ "$#" -eq 0 ]; then
    echo "no arguments provided"
    exit 1
fi

picom.sh -s
setupMonitors.sh disable_FFCP
gamemoderun "$@"
wait
setupMonitors.sh enable_FFCP
picom.sh
