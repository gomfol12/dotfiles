#!/bin/sh

if [ -n "$(bspc query -N -n .focused.tiled -d)" ]; then
    bspc node -t fullscreen
    exit
fi

floating="$(bspc query -N -n .focused.floating -d)"
if [ -n "$floating" ]; then
    echo "$floating" >> /tmp/bspwm_floatFull
    bspc node -t fullscreen
    exit
fi

fullscreen=$(bspc query -N -n .focused.fullscreen)
if [ -n "$fullscreen" ]; then
    nodes=""
    [ -f "/tmp/bspwm_floatFull" ] && nodes=$(cat /tmp/bspwm_floatFull)

    for node in $nodes; do
        if [ "$node" = "$fullscreen" ]; then
            bspc node -t floating
            sed -i /^"$node"/d /tmp/bspwm_floatFull
            exit
        fi
    done

    bspc node -t tiled
    exit
fi
