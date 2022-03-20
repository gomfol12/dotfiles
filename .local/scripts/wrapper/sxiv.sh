#!/bin/sh
if command -v nsxiv >/dev/null 2>&1; then
    if [ "$#" -eq 1 ] && [ -d "$1" ]; then
        find "$1" -type f -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}' | sort -V | sed 's/.*/"&"/' | xargs -r nsxiv -a -t
        exit
    fi
    echo "$@" | xargs -r nsxiv -a
    exit
else
    echo "please install nsxiv"
    exit 1
fi
