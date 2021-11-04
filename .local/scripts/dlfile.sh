#!/bin/sh

url=$(dragon-drag-and-drop -t -x)

if [ -n "$url" ]; then
    printf "File Name: "
    name=""
    while [ -z "$name" ] || [ -e "$name" ]; do
        read -r name
        name="$name""$(echo "$url" | rev | grep -o '^[A-Za-z]*\.' | rev)"
        if [ -e "$name" ]; then
            printf "File already exists, overwrite (y|n): "
            read -r ans

            if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
                break
            else
                printf "File Name: "
            fi
        fi
    done

    [ -n "$name" ] && curl -o "$name" "$url" || exit 1
else
    exit 1
fi
