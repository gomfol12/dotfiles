#!/bin/sh -e
# original script from https://github.com/AN3223/scripts/blob/master/doasedit

help()
{
    cat - >&2 <<EOF
doasedit - like sudoedit, but for doas
doasedit file...
Every argument will be treated as a file to edit. There's no support for
passing arguments to doas, so you can only doas root.
This script is SECURITY SENSITIVE! Special care has been taken to correctly
preserve file attributes. Please exercise CAUTION when modifying AND using
this script.
EOF
}

if [ "$#" -eq 0 ]; then
    help
    exit 0
fi

case "$1" in
--help | -h)
    help
    exit 0
    ;;
*) ;;
esac

export TMPDIR=/dev/shm/
trap 'trap - EXIT HUP QUIT TERM INT ABRT; rm -f "$tmp" "$tmpcopy"' EXIT HUP QUIT TERM INT ABRT

doas_retry()
{
    attempts=0
    max_attempts=3

    while [ $attempts -lt $max_attempts ]; do
        if doas "$@"; then
            return 0
        fi
        attempts=$((attempts + 1))
    done

    exit 1
}

for file; do
    case "$file" in -*) file=./"$file" ;; esac

    file_without_extension="${file%.*}"
    file_extension="${file##*.}"
    tmp=""
    if [ "$file_extension" = "$file_without_extension" ]; then
        tmp="$(mktemp)"
    else
        tmp="$(mktemp --suffix=".$file_extension")"
    fi

    if [ -f "$file" ] && [ ! -r "$file" ]; then
        doas_retry cat "$file" >"$tmp"
    elif [ -r "$file" ]; then
        cat "$file" >"$tmp"
    fi

    tmpcopy="$(mktemp)"
    cat "$tmp" >"$tmpcopy"

    ${EDITOR:-vi} "$tmp"

    if cmp -s "$tmp" "$tmpcopy"; then
        echo 'File unchanged, exiting...'
    else
        doas_retry dd if="$tmp" of="$file"
        echo 'Done, changes written'
    fi

    rm "$tmp" "$tmpcopy"
done
