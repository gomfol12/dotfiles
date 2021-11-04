#!/bin/bash
if command -v sxiv >/dev/null 2>&1; then
    if [ "$#" -gt 1 ]; then
        for arg in "$@"; do
            if [ ! -f "$arg" ] && grep -q 'image/*' "$(file --mime-type "$arg" -bL)"; then
                printf 'Not a file or image: %s\n' "$arg" >&2
                exit 1
            fi
        done
        sxiv -a "$@"
    elif [ "$#" -eq 1 ]; then
        if [ -f "$1" ]; then
            if grep -q 'image/*' "$(file --mime-type "$arg" -bL)"; then
                sxiv -a "$1"
            else
                printf 'Not a file or image: %s\n' "$arg" >&2
                exit 1
            fi
        elif [ -d "$1" ]; then
            find "$1" -maxdepth 1 -type f -exec file --mime-type {} \; | grep ' image/.*$' | cut -d':' -f1 | sed -e 's/^\|$/"/g' | sort -V | tr "\n" " " | xargs -r sxiv -a -t
        fi
    fi
else
	echo "please install sxiv"
fi
