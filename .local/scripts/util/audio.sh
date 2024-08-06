#!/bin/bash
# REWORK AGAIN ??? still not satisfied with the script
# wpctl ???
# bindel=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
# bindel=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
# bindl=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
# # Requires playerctl
# bindl=, XF86AudioPlay, exec, playerctl play-pause
# bindl=, XF86AudioPrev, exec, playerctl previous
# bindl=, XF86AudioNext, exec, playerctl next

config_file="${XDG_CONFIG_HOME:-"$HOME/.config"}/audioctl"
players=$(playerctl --list-all --no-messages)

# check if audio is ready
default_sink=$(pactl get-default-sink)
[ "$default_sink" = "@DEFAULT_SINK@" ] && exit 1

log()
{
    printf "%s\n" "$1" | xargs
}

# $1 sink|source
get_user_info()
{
    if [ "$1" = "sink" ]; then
        sinks_raw="$(pactl list sinks)"
        sinks_count="$(pactl list sinks | grep -cE "^Sink #[0-9]+")"
    elif [ "$1" = "source" ]; then
        sinks_raw="$(pactl list sources)"
        sinks_count="$(pactl list sources | grep -cE "^Source #[0-9]+")"
    else
        log "Error: user_get_info argument required"
        exit 1
    fi

    # error checking
    if [ -z "$sinks_raw" ] || [ -z "$sinks_count" ]; then
        log "Error: Cant get speaker data"
        exit 1
    fi

    names=()
    descs=()

    counter=0
    IFS=$'\n'
    # get sink names
    for name in $(echo "$sinks_raw" | grep "Name:.*$" | sed 's/[[:space:]]*Name: //'); do
        names[counter]=$name
        counter=$((counter + 1))
    done
    counter=0
    # get sink desc
    for desc in $(echo "$sinks_raw" | grep "Description:.*$" | sed 's/[[:space:]]*Description: //'); do
        descs[counter]=$desc
        counter=$((counter + 1))
    done

    # print for user
    for ((i = 0; i < sinks_count; i++)); do
        # error checking
        if [ -z "${descs[i]}" ]; then
            log "Error: Cant get speaker data"
            exit 1
        fi
        log "$i: ${descs[i]}"
    done
    # read from user
    while read -p "[0]: " -r select; do
        if [[ $select =~ [[:digit:]]+ ]] && [ "$select" -lt "$sinks_count" ]; then
            # error checking
            if [ -z "${names[$select]}" ]; then
                log "Error: Cant get speaker data"
                exit 1
            fi
            select=${names[$select]}
            break
        fi
        if [ -z "$select" ]; then
            select=${names[0]}
            break
        fi
        log "Invalid input! Try again."
    done
}

setup()
{
    log "--- setup ---"
    log "speaker:"
    get_user_info "sink"
    speaker=$select
    log "headphones:"
    get_user_info "sink"
    headphones=$select
    log "microphone:"
    get_user_info "source"
    microphone=$select

    echo "speaker:$speaker" >"$config_file"
    echo "headphones:$headphones" >>"$config_file"
    echo "microphone:$microphone" >>"$config_file"
}

load_config()
{
    if [ -f "$config_file" ]; then
        speaker=$(grep "speaker:" "$config_file" | cut -d ":" -f 2)
        headphones=$(grep "headphones:" "$config_file" | cut -d ":" -f 2)
        microphone=$(grep "microphone:" "$config_file" | cut -d ":" -f 2)
    else
        log "Error: Cant find config file. Starting setup..."
        setup
    fi
}
load_config

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
                noisetorch -u
            fi
            if [ "$mute_status" = "Mute: no" ]; then
                if ! pactl list sources | grep -q "Name: NoiseTorch.*"; then
                    noisetorch -i -s "$microphone" -t 65
                fi
            fi
            ;;
        "set")
            if [ "$3" = "on" ]; then
                noisetorch -u
                pactl set-source-mute "$microphone" 1
            elif [ "$3" = "off" ]; then
                if ! pactl list sources | grep -q "Name: NoiseTorch.*"; then
                    noisetorch -i -s "$microphone" -t 65
                fi
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
        noisetorch -u
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
    elif [ "$default_sink" = "$headphones" ]; then
        echo "device: headphones"
    else
        echo "device: unknown"
    fi
    echo "sink_volume: $(get_default_sink_volume)"
    echo "sink_mute: $(mute "sink" "get")"
    echo "microphone_mute: $(mute "microphone" "get")"
}

restart_easyeffects()
{
    if command -v easyeffects >/dev/null 2>&1; then
        if [ -n "$(pgrep -u "$(id -u)" -n "easyeffects")" ]; then
            killall easyeffects
        fi

        setsid -f -- easyeffects --gapplication-service
    fi
}

restart_pipewire()
{
    if [ -n "$(pgrep -u "$(id -u)" -n "pipewire")" ]; then
        systemctl --user restart pipewire
        systemctl --user restart pipewire-pulse
        systemctl --user restart wireplumber
    else
        printf "pipewire is not running\n"
        exit 1
    fi

    restart_easyeffects
}

help()
{
    cat <<EOF
audio.sh - audio/mic control
usage - audio.sh [command] [subcommand|value]
    setup:          setup config file for script
    default:        set the default audio output and input
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
    restart:        restart pipewire
    easyeffects:    restart easyeffects
    help:           help menu
EOF
}

case "$1" in
"setup") setup ;;
"default") setup_default_source_sink ;;
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

"restart") restart_pipewire ;;

"easyeffects") restart_easyeffects ;;

"help") help ;;
*) log "Invalid argument. Try help for help" ;;
esac
