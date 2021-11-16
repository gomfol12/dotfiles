#!/bin/sh
if command -v sxiv >/dev/null 2>&1; then
    if [ "$#" -ge 1 ]; then
        if [ -d "$1" ]; then
            find "$1" -maxdepth 1 -type f -exec file --mime-type {} \; | grep ' image/.*$' | cut -d':' -f1 | sed -e 's/^\|$/"/g' | sort -V | tr "\n" " " | xargs -r sxiv -a -t
            exit 1
        fi
        for arg in "$@"; do
            if [ ! -f "$arg" ] && grep -q 'image/*' "$(file --mime-type "$arg" -bL)"; then
                printf 'Not a file or image: %s\n' "$arg" >&2
                exit 1
            fi
        done
        sxiv -a "$@"
    elif [ "$#" -eq 0 ]; then
        echo "No image provided"
    fi
else
	echo "please install sxiv"
fi
