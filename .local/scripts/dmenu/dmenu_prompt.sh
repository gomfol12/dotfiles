#!/bin/sh
action=$(printf "no\nyes\n" | dmenu -p "$1")
[ "$action" = "yes" ] && $2 || exit
