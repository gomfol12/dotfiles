#!/bin/sh
#TODO: microphone noise cancel, mute

speaker="alsa_output.pci-0000_2b_00.3.analog-stereo"
headphones="alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo"

default_sink=$(pactl get-default-sink)
players=$(playerctl --list-all --no-messages)

log()
{
    printf "%s\n" "$1" | xargs
}

swap_audio_outputs()
{
    if [ "$default_sink" = "$speaker" ]; then
        pactl set-default-sink "$headphones"
    fi
    if [ "$default_sink" = "$headphones" ]; then
        pactl set-default-sink "$speaker"
    fi
}

get_audio_device()
{
    if [ "$default_sink" = "$speaker" ]; then
        echo "speaker"
    fi
    if [ "$default_sink" = "$headphones" ]; then
        echo "headphones"
    fi
}

set_default_sink_volume()
{
    pactl set-sink-volume "$default_sink" "$1"
}

get_default_sink_volume()
{
    pactl get-sink-volume "$default_sink" | grep -oE "[0-9]*%" | head -1
}

reset_volume()
{
    pactl list sinks | grep "Name: " | sed 's/[[:space:]]*Name: //' | while read -r line; do
        pactl set-sink-volume "$line" 100%
    done
}

toggle_default_sink_mute()
{
    pactl set-sink-mute "$default_sink" toggle
}

setup_player()
{
    # start playerctl daemon if not already started
    if [ ! "$(pgrep -u "$(id -u)" -nf "playerctld")" ]; then
        playerctld daemon
    fi

    # start spotify if no player has been started yet
    if [ -z "$players" ]; then
        spotify >/dev/null 2>&1 &
        if [ "$1" = "play" ]; then
            sleep 2 && playerctl --player spotify play
        fi
        return
    fi
}

play_pause()
{
    setup_player "play"

    # calculate number of playing clients
    num_playing=0
    for player in ${players}; do
        if [ "$(playerctl --player "$player" status)" = "Playing" ]; then
            num_playing=$((num_playing + 1))
        fi
    done

    # pause all clients if more than one is playing otherwise play-pause the client
    if [ "$num_playing" -gt 1 ]; then
        playerctl --all-players pause
    else
        playerctl play-pause
    fi
}

prev_track()
{
    setup_player ""
    playerctl previous
}

next_track()
{
    setup_player ""
    playerctl next
}

stop()
{
    playerctl stop
}

spotifyctl()
{
    case "$1" in
    "stop") playerctl --player spotify stop ;;
    "play-pause") playerctl --player spotify play-pause ;;
    "prev" | "previous") playerctl --player spotify previous ;;
    "next") playerctl --player spotify next ;;
    "play") playerctl --player spotify play ;;
    "pause") playerctl --player spotify pause ;;
    *) log "Invalid argument. Try help for help" ;;
    esac
}

help()
{
    cat <<EOF
audio.sh - audio/mic control
usage - audio.sh [command] [subcommand|value]
    swap:           swap audio output speaker/headphones
    device:         get current audio output device
    volume:         control volume
        num:            set volume level to num (leading % is needed)
        inc:            increase volume (by 5%)
        dec:            decrease volume (by 5%)
        get:            get volume level
        reset:          reset to default volume level (100%)
    mute:           toggle mute
    play-pause:     play-pause last audio source
    next:           next track
    previous:       previous track
    stop:           stop track
    spotify:        spotify commands
        stop:           stop track
        play-pause:     play-pause track
        previous:       previous track
        next:           next track
        play:           play track
        pause:          pause track
    help:           help menu
EOF
}

case "$1" in
"switch" | "swap") swap_audio_outputs ;;
"device") get_audio_device ;;
"volume")
    case "$2" in
    "inc" | "+") set_default_sink_volume "+5%" ;;
    "dec" | "-") set_default_sink_volume "-5%" ;;
    "get") get_default_sink_volume ;;
    "reset") reset_volume ;;
    *)
        if [ -n "$2" ] && (echo "$2" | grep -q "%"); then
            set_default_sink_volume "$2"
        else
            log "Please provide volume level [number]% or lookup help for more"
        fi
        ;;
    esac
    ;;
"mute") toggle_default_sink_mute ;;
"play-pause" | "play_pause") play_pause ;;
"next") next_track ;;
"prev" | "previous") prev_track ;;
"stop") stop ;;
"spotify") spotifyctl "$2" ;;
"help") help ;;
*) log "Invalid argument. Try help for help" ;;
esac
