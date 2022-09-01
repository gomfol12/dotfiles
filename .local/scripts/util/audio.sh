#!/bin/sh
# TODO: messy script clean up

speaker="alsa_output.pci-0000_2b_00.3.analog-stereo"
headphones="alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo"
microphone="alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.mono-fallback"

default_sink=$(pactl get-default-sink)
players=$(playerctl --list-all --no-messages)

log()
{
    printf "%s\n" "$1" | xargs
}

# swap
swap_audio_outputs()
{
    if [ "$default_sink" = "$speaker" ]; then
        pactl set-default-sink "$headphones"
    fi
    if [ "$default_sink" = "$headphones" ]; then
        pactl set-default-sink "$speaker"
    fi
}

# setup default source sink
setup_default_source_sink()
{
    pactl set-default-sink "$speaker"
    pactl set-default-source "$microphone"
}

# volume contorl
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

# mute sink
mute()
{
    case "$1" in
    "sink")
        case "$2" in
        "toggle") pactl set-sink-mute "$default_sink" toggle ;;
        "set")
            if [ "$3" = "on" ]; then
                pactl set-sink-mute "$default_sink" 1
            elif [ "$3" = "off" ]; then
                pactl set-sink-mute "$default_sink" 0
            else
                log "Invalid argument. Try help for help"
            fi
            ;;
        "get") pactl get-sink-mute "$default_sink" | sed "s/Mute: //" ;;
        *) log "Invalid argument. Try help for help" ;;
        esac
        ;;
    "microphone" | "mic")
        case "$2" in
        "toggle")
            pactl set-source-mute "$microphone" toggle

            mute_status=$(pactl get-source-mute "$microphone")
            if [ "$mute_status" = "Mute: yes" ]; then
                systemctl --user stop noisetorch
            fi
            if [ "$mute_status" = "Mute: no" ]; then
                systemctl --user start noisetorch
            fi
            ;;
        "set")
            if [ "$3" = "on" ]; then
                systemctl --user stop noisetorch
                pactl set-source-mute "$microphone" 1
            elif [ "$3" = "off" ]; then
                systemctl --user start noisetorch
                pactl set-source-mute "$microphone" 0
            else
                log "Invalid argument. Try help for help"
            fi
            ;;
        "get") pactl get-source-mute "$microphone" | sed "s/Mute: //" ;;
        *) log "Invalid argument. Try help for help" ;;
        esac
        ;;
    "all")
        pactl set-sink-mute "$default_sink" 1
        pactl set-source-mute "$microphone" 1
        systemctl --user stop noisetorch
        playerctl stop
        ;;
    *) log "Invalid argument. Try help for help" ;;
    esac
}

players()
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
    fi

    case "$1" in
    "stop") playerctl stop ;;
    "play-pause" | "play_pause")
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
        ;;
    "prev" | "previous") playerctl previous ;;
    "next") playerctl next ;;
    "play") playerctl play ;;
    "pause") playerctl pause ;;
    *) log "Invalid argument. Try help for help" ;;
    esac
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

# get sink source info
get_sink_source_info()
{
    if [ "$default_sink" = "$speaker" ]; then
        echo "device: speaker"
    fi
    if [ "$default_sink" = "$headphones" ]; then
        echo "device: headphones"
    fi
    echo "sink_volume: $(get_default_sink_volume)"
    echo "sink_mute: $(mute "sink" "get")"
    echo "microphone_mute: $(mute "microphone" "get")"
}

help()
{
    cat <<EOF
audio.sh - audio/mic control
usage - audio.sh [command] [subcommand|value]
    setup:          setup default devices
    swap:           swap audio output speaker/headphones
    info:           info
    volume:         control volume
        num:            set volume level to num (leading % is needed)
        inc:            increase volume (by 5%)
        dec:            decrease volume (by 5%)
        get:            get volume level
        reset:          reset to default volume level (100%)
    mute:           mute control
        sink:           control default sink
            toggle:         toggle mute
            get:            get mute status
            set:            set mute status
                yes:            activate mute
                no:             deactivate mute
        microphone:     control microphone
            toggle:         toggle mute
            get:            get mute status
            set:            set mute status
                yes:            activate mute
                no:             deactivate mute
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
"setup") setup_default_source_sink ;;

"switch" | "swap") swap_audio_outputs ;;

"info") get_sink_source_info ;;

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

"mute")
    shift
    mute "$@"
    ;;

"stop") players "stop" ;;
"play-pause" | "play_pause") players "play-pause" ;;
"next") players "next" ;;
"prev" | "previous") players "prev" ;;
"play") players "play" ;;
"pause") players "pause" ;;

"spotify") spotifyctl "$2" ;;

"help") help ;;
*) log "Invalid argument. Try help for help" ;;
esac
