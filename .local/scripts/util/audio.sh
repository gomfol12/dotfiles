#!/bin/bash

UPDATE_EWW=1
HEADPHONES="alsa_output.usb-Corsair_CORSAIR_HS80_RGB_Wireless_Gaming_Receiver_18e05f2e000700dc-00.analog-stereo"

LAST_PLAYER_FILE="/tmp/last_media_player"
NUM_PLAYING=""
PLAYING_PLAYERS=()

update_eww()
{
    if ! [ "$UPDATE_EWW" -eq 1 ]; then
        return
    fi

    local sink_mute
    sink_mute=$(get_default_sink_mute)
    local mic_mute
    mic_mute=$(get_default_source_mute)
    local volume
    volume=$(get_default_sink_volume)
    volume="${volume%\%}" # strip percentage sign

    local sink_icon
    local default_sink
    default_sink=$(get_default_sink)

    if [ "$default_sink" = "$HEADPHONES" ]; then
        sink_icon=$([ "$sink_mute" = "yes" ] && echo "󰟎 " || echo "󰋋 ")
    else
        if [ "$sink_mute" = "yes" ]; then
            sink_icon="󰝟 "
        elif [ "$volume" -eq 0 ]; then
            sink_icon=" "
        elif [ "$volume" -lt 50 ]; then
            sink_icon=" "
        elif [ "$volume" -le 100 ]; then
            sink_icon=" "
        else
            sink_icon="󰝟 "
        fi
    fi

    eww update mic_icon="$([ "$mic_mute" = "yes" ] && echo " " || echo "")"
    eww update volume="$volume%" sink_icon="$sink_icon"
}

convert_to_percent()
{
    printf "%.0f%%\n" "$(echo "$1 * 100" | bc -l)"
}

kill_nuclear()
{
    pid=$(pgrep -u "$(id -u)" -n "$1")
    if [ -n "$pid" ]; then
        kill -9 "$pid"
    fi
}

kill_graceful()
{
    pid=$(pgrep -u "$(id -u)" -n "$1")
    if [ -n "$pid" ]; then
        kill "$pid"
    fi
}

# get all sinks and exclude "loopback" and "easy effects sinks" sinks
get_sinks()
{
    pw-dump | jq 'map(select(.info.props."media.class" == "Audio/Sink"
    and (.info.props."node.description" | test("^(?!Loopback|Easy Effects Sink).*"))))
    | map({
        id,
        "node.name": .info.props."node.name",
        "node.description": .info.props."node.description"
    })'
}

get_default_sink()
{
    wpctl inspect @DEFAULT_AUDIO_SINK@ | grep "node.name" | cut -d"\"" -f2
}

get_default_sink_volume()
{
    convert_to_percent "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d" " -f2)"
}

get_default_sink_mute()
{
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
        echo "yes"
    else
        echo "no"
    fi
}

set_default_sink()
{
    wpctl set-default "$1"
    update_eww
}

set_default_sink_volume()
{
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ "$1"
    update_eww
}

set_default_sink_mute()
{
    wpctl set-mute @DEFAULT_AUDIO_SINK@ "$1"
    update_eww
}

# get all sources and exclude "loopback" sources
get_sources()
{
    pw-dump | jq 'map(select((.info.props."media.class" == "Audio/Source"
    or .info.props."media.class" == "Audio/Source/Virtual")
    and (.info.props."node.description" | test("^(?!Loopback).*"))))
    | map({
        id,
        "node.name": .info.props."node.name",
        "node.description": .info.props."node.description"
    })'
}

get_default_source()
{
    wpctl inspect @DEFAULT_AUDIO_SOURCE@ | grep "node.name" | cut -d"\"" -f2
}

get_default_source_mute()
{
    if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
        echo "yes"
    else
        echo "no"
    fi
}

set_default_source()
{
    wpctl set-default "$1"
    update_eww
}

set_default_source_mute()
{
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ "$1"
    update_eww
}

swap_audio_outputs()
{
    if [ "$(get_sinks | jq -r 'length')" -lt 2 ]; then
        echo "Not enough audio sinks to swap"
        return
    fi

    set_default_sink "$(get_sinks | jq -r '.[] | select(.["node.name"] != "'"$(get_default_sink)"'") | .id' | cut -d" " -f1)"

    if [ "$(get_default_sink)" = "$HEADPHONES" ]; then
        setsid -f -- pw-play --latency=500ms --raw --format=f32 /dev/zero
    else
        kill_nuclear "pw-play"
    fi
}

get_sink_source_info()
{
    echo "device: speaker"
    echo "sink_volume: $(get_default_sink_volume)"
    echo "sink_mute: $(get_default_sink_mute)"
    echo "microphone_mute: $(get_default_source_mute)"
}

restart_easyeffects()
{
    if command -v easyeffects >/dev/null 2>&1; then
        kill_nuclear "pw-play"
        kill_graceful "easyeffects"

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

get_players_state()
{
    for player in $(playerctl -l); do
        status=$(playerctl -p "$player" status 2>/dev/null)

        if [ "$status" = "Playing" ]; then
            PLAYING_PLAYERS+=("$player")
        fi
    done

    NUM_PLAYING=${#PLAYING_PLAYERS[@]}
}

get_active_player()
{
    get_players_state

    # if something is playing, return the first one
    if [ "$NUM_PLAYING" -gt 0 ]; then
        echo "${PLAYING_PLAYERS[0]}"
        # remember last active player
        echo "${PLAYING_PLAYERS[0]}" >"$LAST_PLAYER_FILE"
        return
    fi

    # fallback to last known player
    if [ -f "$LAST_PLAYER_FILE" ]; then
        last=$(cat "$LAST_PLAYER_FILE")
        if playerctl -l | grep -qx "$last"; then
            echo "$last"
            return
        fi
    fi

    # final fallback
    playerctl -l | head -n1
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
    restart:        restart pipewire
    easyeffects:    restart easyeffects
    cracklingfix:   fix audio crackling when playing some games (e.g. Cookie Clicker)
    help:           help menu
EOF
}

if [ "$1" = "noeww" ]; then
    UPDATE_EWW=0
    shift
fi
if [ "$1" = "eww" ]; then
    shift
fi

case "$1" in
"switch" | "swap")
    swap_audio_outputs
    ;;
"info")
    get_sink_source_info
    ;;
"volume")
    shift
    case "$1" in
    "inc" | "+")
        set_default_sink_volume 5%+
        ;;
    "dec" | "-")
        set_default_sink_volume 5%-
        ;;
    "get")
        get_default_sink_volume
        ;;
    "reset")
        set_default_sink_volume 100%
        ;;
    *)
        set_default_sink_volume "$1"
        ;;
    esac
    ;;
"mute")
    shift
    case "$1" in
    "sink")
        case "$2" in
        "set")
            if [ "$3" = "on" ]; then
                set_default_sink_mute 1
            elif [ "$3" = "off" ]; then
                set_default_sink_mute 0
            else
                help
            fi
            ;;
        "get")
            get_default_sink_mute
            ;;
        *)
            set_default_sink_mute "toggle"
            ;;
        esac
        ;;
    "microphone" | "mic")
        case "$2" in
        "set")
            if [ "$3" = "on" ]; then
                set_default_source_mute 1
            elif [ "$3" = "off" ]; then
                set_default_source_mute 0
            else
                help
            fi
            ;;
        "get")
            get_default_source_mute
            ;;
        *)
            set_default_source_mute "toggle"
            ;;
        esac
        ;;
    "all")
        set_default_sink_mute 1
        set_default_source_mute 1
        playerctl pause
        ;;
    *)
        help
        ;;
    esac
    ;;
"stop")
    active_player=$(get_active_player)
    [ -n "$active_player" ] && playerctl -p "$active_player" stop
    ;;
"play-pause" | "play_pause")
    get_players_state
    active_player=$(get_active_player)

    # if multiple players are playing, pause all
    if [ "$NUM_PLAYING" -gt 1 ]; then
        playerctl --all-players pause
    else
        [ -n "$active_player" ] && playerctl -p "$active_player" play-pause
    fi
    ;;
"prev" | "previous")
    active_player=$(get_active_player)
    [ -n "$active_player" ] && playerctl -p "$active_player" previous
    ;;
"next")
    active_player=$(get_active_player)
    [ -n "$active_player" ] && playerctl -p "$active_player" next
    ;;
"play")
    active_player=$(get_active_player)
    [ -n "$active_player" ] && playerctl -p "$active_player" play
    ;;
"pause")
    active_player=$(get_active_player)
    [ -n "$active_player" ] && playerctl -p "$active_player" pause
    ;;
"restart")
    restart_pipewire
    ;;
"easyeffects")
    restart_easyeffects
    ;;
"cracklingfix")
    # this fixes audio crackling when playing some games (e.g. Cookie Clicker).
    pw-metadata -n settings 0 clock.force-rate 48000 && pw-metadata -n settings 0 clock.force-quantum 500
    ;;
*)
    help
    ;;
esac
