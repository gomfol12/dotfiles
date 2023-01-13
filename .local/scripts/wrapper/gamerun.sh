#!/bin/sh

if [ "$#" -eq 0 ]; then
    echo "no arguments provided"
    exit 1
fi

export ALSOFT_DRIVERS=pulse

compositor.sh -s
[ "$(hostname)" = "$HOSTNAME_DESKTOP" ] && setupMonitors.sh disable_FFCP
gamemoderun "$@"
wait
[ "$(hostname)" = "$HOSTNAME_DESKTOP" ] && setupMonitors.sh enable_FFCP
compositor.sh
