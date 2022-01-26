#!/bin/sh

if test -t 0 -a -t 1 -a -t 2; then
    if command -v fontpreview-ueberzug >/dev/null 2>&1; then
        fontpreview-ueberzug
        exit 0
    else
        printf "fontpreview-ueberzug is not installed. Install it\n"
        exit 1
    fi
fi

# fallback if fontpreview-ueberzug is not installed
if ! command -v dmenu >/dev/null 2>&1; then
    printf "dmenu is not installed. Install it\n"
    exit 1
fi
choice=$(fc-list | cut -d : -f1 | dmenu -l 20 -p "Fontviewer: ")

if test -n "$choice"; then
    display "$choice"
else
    exit 1
fi
