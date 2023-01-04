#!/bin/sh
logfile=$1

dbus-monitor "interface='org.freedesktop.Notifications'" |
    grep --line-buffered "string" |
    grep --line-buffered -e method -e ":" -e '""' -e urgency -e notify -v |
    grep --line-buffered '.*(?=string)|(?<=string).*' -oPi |
    grep --line-buffered -v '^\s*$' |
    xargs -I '{}' printf "----- $(date +'%a %d.%m.%Y %H:%M:%S %Z') -----\n{}\n" >>"$logfile"
