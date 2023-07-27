#!/bin/sh

expr=$(echo "" | dmenu -p "Calculate:" -l 1)

if [ -z "$expr" ]; then
    exit
fi

erg=$(qalc "$expr")

copy=$(printf "%s\n" "$erg" | dmenu -p "Result:" -l "$(echo "$erg" | wc -l)")

if [ -n "$copy" ]; then
    printf "%s" "$copy" | xclip -selection clipboard
fi
