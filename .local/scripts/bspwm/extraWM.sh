#!/bin/bash

TOP_PADDING=24
BORDER_WIDTH=2
PRIMARY=HDMI-0
SECOUND=DVI-D-0

PRIMARY=$(bspc query -M -m $PRIMARY)
SECOUND=$(bspc query -M -m $SECOUND)
PRIMARY_PID=$(cat /tmp/polybar_primary_pid)
SECOUND_PID=$(cat /tmp/polybar_secound_pid)

HideBarPrimary()
{
    polybar-msg -p "$PRIMARY_PID" cmd hide >&/dev/null
    bspc config -m "$PRIMARY" top_padding 0
}

HideBarSecound()
{
    polybar-msg -p "$SECOUND_PID" cmd hide >&/dev/null
    bspc config -m "$SECOUND" top_padding 0
}

ShowBarPrimary()
{
    polybar-msg -p "$PRIMARY_PID" cmd show >&/dev/null
    bspc config -m "$PRIMARY" top_padding $TOP_PADDING
}

ShowBarSecound()
{
    polybar-msg -p "$SECOUND_PID" cmd show >&/dev/null
    bspc config -m "$SECOUND" top_padding $TOP_PADDING
}


HideNodes()
{
    for node in $1; do
        [ "$(isPopup "$node")" -eq 1 ] && continue
        bspc node "$node" -g hidden=on
    done
}

HideAll()
{
    HideNodes "$(bspc query -N -n .window -d "$1")"
}

HideAllButNotFocused()
{
    focused=$(bspc query -N -n .focused -d "$1")
    if [ "$(isPopup $focused)" -eq 1 ]; then
        HideNodes "$(bspc query -N -n .window.\!focused -d "$1" | tail -n +2)"
    else
        HideNodes "$(bspc query -N -n .window.\!focused -d "$1")"
    fi
}

ShowNodes()
{
    for node in $1; do
        bspc node "$node" -g hidden=off
    done
}

ShowAll()
{
    ShowNodes "$(bspc query -N -n .hidden -d "$1")"
}

getDesktopLayout()
{
    [ -f "/tmp/bspwm_layout_$1" ] && Layout=$(cat /tmp/bspwm_layout_$1)
    [ -z "$Layout" ] && Layout=tiled

    echo $Layout
}

isPopup()
{
    if [ -n "$(xprop -id $1 | grep -o '_NET_WM_WINDOW_TYPE_DIALOG')" ]; then
        echo 1
    else
        echo 0
    fi
}

correctBorders()
{
    tiled=$(bspc query -N -n .tiled -d "$1")
    tiledCount=$(echo $tiled | wc -w)

    [ "$tiledCount" -eq 1 ] && bspc config -n "$tiled" border_width 0

    if [ "$tiledCount" -gt 1 ]; then
        for node in $tiled; do
            bspc config -n "$node" border_width $BORDER_WIDTH
        done
    fi
}
# correct on startup and restart
for desktop in $(bspc query -D); do
    correctBorders "$desktop"
done

bspc subscribe node_state | while read -r Event Monitor Desktop Node State Active; do

# Hide bar and nodes on fullscreen event on current desktop
    if [ "$State" = "fullscreen" ]; then
        if [ "$Active" = "on" ]; then
            if [ "$Monitor" = "$PRIMARY" ]; then
                HideBarPrimary
            elif [ "$Monitor" = "$SECOUND" ]; then
                HideBarSecound
            fi
            HideAllButNotFocused "$Desktop"
        elif [ "$Active" = "off" ]; then
            if [ "$Monitor" = "$PRIMARY" ]; then
                ShowBarPrimary
            elif [ "$Monitor" = "$SECOUND" ]; then
                ShowBarSecound
            fi
            ShowAll "$Desktop"
        fi
    fi

# correct border when going floating after single tiled
    if [ "$State" = "floating" ] && [ "$Active" = "on" ]; then
        bspc config -n "$Node" border_width $BORDER_WIDTH
    fi

# show window when a window goes floating in monocle and hide when go tiled again
    if [ -f "/tmp/bspwm_layout_$Desktop" ] && [ "$(cat /tmp/bspwm_layout_$Desktop)" = "monocle" ] && [ "$State" = "floating" ]; then
        if [ "$Active" = "on" ]; then
            ShowNodes "$(bspc query -N -n .window -d $Desktop | head -1)"
        elif [ "$Active" = "off" ]; then
            HideAllButNotFocused "$Desktop"
        fi
    fi

    correctBorders "$Desktop"
done &

bspc subscribe node_remove | while read -r Event Monitor Desktop Node; do

# Show bar and nodes when no nodes are fullscreen on current desktop
    if [ -z "$(bspc query -N -n .fullscreen -d "$Desktop")" ]; then
            if [ "$Monitor" = "$PRIMARY" ]; then
                ShowBarPrimary
            elif [ "$Monitor" = "$SECOUND" ]; then
                ShowBarSecound
            fi
            ShowAll "$Desktop"
    fi

# Hide nodes when one gets removed in monocle mode
    Layout=$(getDesktopLayout $Desktop)
    if [ "$Layout" = "monocle" ]; then
        # go back to tiled mode when only one or none window is left
        tiled=$(bspc query -N -n .tiled -d "$Desktop")
        [ $(echo $tiled | wc -w) -le 1 ] && bspc desktop --layout tiled

        HideAllButNotFocused $Desktop
    fi

    correctBorders "$Desktop"
done &

bspc subscribe node_transfer | while read -r Event SrcMonitor SrcDesktop SrcNode DestMonitor DestDesktop DestNode; do

# Show bar and nodes on src desktop and hide bar and nodes on dest desktop
# If src node is in fullscreen
    if [ -n "$(bspc query -N -n "$SrcNode".fullscreen)" ]; then
        ShowAll "$SrcDesktop"
        HideAll "$DestDesktop"

        if [ "$SrcMonitor" = "$PRIMARY" ]; then
            ShowBarPrimary
        elif [ "$SrcMonitor" = "$SECOUND" ]; then
            ShowBarSecound
        fi

        if [ "$DestMonitor" = "$PRIMARY" ]; then
            HideBarPrimary
        elif [ "$DestMonitor" = "$SECOUND" ]; then
            HideBarSecound
        fi
    fi
# Nodes in fullscreen overlap each other

# Show/Hide nodes when transfering nodes in monocle mode
    if [ "$(getDesktopLayout $SrcDesktop)" = "monocle" ]; then
        tiled=$(bspc query -N -n .tiled -d $SrcDesktop)

        # go back to tiled mode when only one or none window is left
        [ $(echo $tiled | wc -w) -le 1 ] && bspc desktop $SrcDesktop --layout tiled

        [ -n "$tiled" ] && bspc node $(echo $tiled | cut -d " " -f 1) -g hidden=off
    fi
    if [ "$(getDesktopLayout $DestDesktop)" = "monocle" ]; then
        HideAllButNotFocused "$DestDesktop"
    fi

    correctBorders "$SrcDesktop"
    correctBorders "$DestDesktop"
done &

bspc subscribe desktop_layout | while read -r Event Monitor Desktop Layout; do

# Hide and Show nodes when switching layouts
    if [ "$Layout" = "monocle" ]; then
        HideAllButNotFocused "$Desktop"

    # convert floating to tiled and save floating window ids
        floating=$(bspc query -N -n .floating -d "$Desktop")
        echo "$floating" > /tmp/bspwm_floating_$Desktop
        for node in $floating; do
            [ "$(isPopup $node)" -eq 1 ] && continue
            bspc node "$node" -t tiled
        done

    elif [ "$Layout" = "tiled" ]; then

    # convert tiled to floating with saved floating window ids
        if [ -f "/tmp/bspwm_floating_$Desktop" ]; then
            floating=$(cat /tmp/bspwm_floating_$Desktop)
            for node in $floating; do
                [ "$(isPopup $node)" -eq 1 ] && continue
                bspc node "$node" -t floating
            done
            rm /tmp/bspwm_floating_$Desktop
        fi

        ShowAll "$Desktop"
    fi

    # info for the monocle navigation script
        echo "$Layout" > /tmp/bspwm_layout_$Desktop
done &

bspc subscribe node_add | while read -r Event Monitor Desktop Ip Node; do

    if [ -f "/tmp/bspwm_layout_$Desktop" ] && [ "$(cat /tmp/bspwm_layout_$Desktop)" = "monocle" ]; then
        if [ -z "$(bspc query -N -n $Node.floating)" ]; then
            HideAllButNotFocused "$Desktop"
        fi
    fi

    correctBorders "$Desktop"
done &
