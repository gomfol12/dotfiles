#!/bin/bash

Desktop=$(bspc query -D -d)

[ -f "/tmp/bspwm_layout_$Desktop" ] && Layout=$(cat /tmp/bspwm_layout_$Desktop)

[ -z "$Layout" ] && Layout=tiled

up()
{
    if [ "$Layout" = "tiled" ]; then
        bspc node -f north
        exit
    fi

    if [ "$Layout" = "monocle" ]; then
        nodes=$(bspc query -N -n .tiled -d)
        [ "$(echo "$nodes" | wc -w)" -eq 1 ] && exit

        focused=$(bspc query -N -n .tiled.focused -d)

        nodeNum=$(echo "$nodes" | wc -w)
        toSelect=$(echo "$nodes" | nl | awk '/'$focused'/ {print $1-1}')

        [ "$toSelect" -lt 1 ] && toSelect=$nodeNum

        bspc node "$focused" -g hidden=on
        bspc node "$(echo $nodes | cut -d " " -f $toSelect)" -g hidden=off -f
        exit
    fi
}

down()
{
    if [ "$Layout" = "tiled" ]; then
        bspc node -f south
        exit
    fi

    if [ "$Layout" = "monocle" ]; then
        nodes=$(bspc query -N -n .tiled -d)
        [ "$(echo "$nodes" | wc -w)" -eq 1 ] && exit

        focused=$(bspc query -N -n .tiled.focused -d)

        nodeNum=$(echo "$nodes" | wc -w)
        toSelect=$(echo "$nodes" | nl | awk '/'$focused'/ {print $1+1}')

        [ "$toSelect" -gt "$nodeNum" ] && toSelect=1

        bspc node "$focused" -g hidden=on
        bspc node "$(echo $nodes | cut -d " " -f $toSelect)" -g hidden=off -f
        exit
    fi
}

upFloating()
{
    if [ "$Layout" = "tiled" ]; then
        nodes=$(bspc query -N -n .floating -d)

        focusedTiled=$(bspc query -N -n .focused.tiled -d)
        if [ -n "$focusedTiled" ]; then
            bspc node "$(echo "$nodes" | head -1)" -f
            exit
        fi

        focused=$(bspc query -N -n .floating.focused -d)

        nodeNum=$(echo "$nodes" | wc -w)
        toSelect=$(echo "$nodes" | nl | awk '/'$focused'/ {print $1-1}')

        [ "$toSelect" -lt 1 ] && toSelect=$nodeNum

        bspc node "$(echo $nodes | cut -d " " -f $toSelect)" -f
    fi
}

downFloating()
{
    if [ "$Layout" = "tiled" ]; then
        nodes=$(bspc query -N -n .floating -d)

        focusedTiled=$(bspc query -N -n .focused.tiled -d)
        if [ -n "$focusedTiled" ]; then
            bspc node "$(echo "$nodes" | head -1)" -f
            exit
        fi

        focused=$(bspc query -N -n .floating.focused -d)

        nodeNum=$(echo "$nodes" | wc -w)
        toSelect=$(echo "$nodes" | nl | awk '/'$focused'/ {print $1+1}')

        [ "$toSelect" -gt "$nodeNum" ] && toSelect=1

        bspc node "$(echo $nodes | cut -d " " -f $toSelect)" -f
    fi
}

case "$1" in
    "up") up; exit ;;
    "down") down; exit ;;
    "upFloat") upFloating; exit ;;
    "downFloat") downFloating; exit ;;
    *) echo "Invalid option"; exit ;;
esac
