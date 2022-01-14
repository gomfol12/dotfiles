#!/bin/sh
if command -v sxiv >/dev/null 2>&1; then
    if [ "$#" -eq 1 ] && [ -d "$1" ]; then
        find "$1" -type f -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}' | sort -V | sed 's/.*/"&"/' | xargs -r sxiv -a -t
        exit
    fi
    echo "$@" | xargs -r sxiv -a
    exit
else
	echo "please install sxiv"
    exit 1
fi
