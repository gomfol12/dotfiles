#!/bin/bash

CONFIG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
CONFIG_FILE="$CONFIG_DIR/weather-info"

PROVIDERS="open-meteo brightsky"
DEFAULT_PROVIDER="open-meteo"

provider=""
location=""

die()
{
    echo "Error: $*" >&2
    exit 1
}

require()
{
    for cmd in "$@"; do
        command -v "$cmd" >/dev/null 2>&1 || die "'$cmd' is required but not installed"
    done
}

http_get()
{
    curl -fsS --max-time 10 "$1"
}

format_val()
{
    if [ -z "$1" ] || [ "$1" = "null" ]; then
        printf "n/a"
        return
    fi
    local v
    v=$(printf "%.0f" "$1")
    [ "$v" = "-0" ] && v=0
    printf "%s" "$v"
}

provider_info()
{
    case "$1" in
    open-meteo) echo "Open-Meteo        - global" ;;
    brightsky) echo "Bright Sky (DWD)  - Germany/Europe" ;;
    esac
}

valid_provider()
{
    local p
    for p in $PROVIDERS; do
        [ "$p" = "$1" ] && return 0
    done
    return 1
}

list_providers()
{
    local p n=1
    for p in $PROVIDERS; do
        local mark=" "
        [ "$p" = "$provider" ] && mark="*"
        printf "%s %d) %-11s %s\n" "$mark" "$n" "$p" "$(provider_info "$p")"
        n=$((n + 1))
    done
}

save_config()
{
    mkdir -p "$CONFIG_DIR"
    printf 'provider="%s"\nlocation="%s"\n' "$provider" "$location" >"$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
}

load_config()
{
    [ -f "$CONFIG_FILE" ] || die "weather-info does not exist. Please run '$0 setup' first"
    provider=$(grep '^provider=' "$CONFIG_FILE" | cut -d'"' -f2)
    location=$(grep '^location=' "$CONFIG_FILE" | cut -d'"' -f2)
    [ -z "$provider" ] && provider="$DEFAULT_PROVIDER"
    valid_provider "$provider" || die "unknown provider '$provider' in config"
    [ -z "$location" ] && die "no location configured. Run '$0 setup'"
}

choose_provider()
{
    local choice p n
    echo "Weather providers:"
    list_providers
    while read -p "Provider [name/number, empty = $DEFAULT_PROVIDER]: " -r choice; do
        [ -z "$choice" ] && choice="$DEFAULT_PROVIDER"
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            n=1
            for p in $PROVIDERS; do
                if [ "$n" -eq "$choice" ]; then
                    provider="$p"
                    return
                fi
                n=$((n + 1))
            done
        elif valid_provider "$choice"; then
            provider="$choice"
            return
        fi
        echo "Invalid provider"
    done
}

setup()
{
    require curl jq
    provider="$DEFAULT_PROVIDER"
    choose_provider

    while read -p "Location [(city,state,country)/auto]: " -r location; do
        if [ -z "$location" ]; then
            echo "Location cannot be empty"
        else
            break
        fi
    done

    save_config
    echo "Saved to $CONFIG_FILE"
}

provider_cmd()
{
    load_config
    if [ -z "$1" ]; then
        list_providers
        return
    fi
    valid_provider "$1" || die "unknown provider '$1' (available: $PROVIDERS)"
    provider="$1"
    save_config
    echo "Provider set to $provider"
}

# Uses the Open-Meteo geocoding API for every provider.
# location format: "city[,state][,country]"  (state/country can be name or country code)
get_coordinates()
{
    COORD_RE='^-?[0-9]+(\.[0-9]+)? -?[0-9]+(\.[0-9]+)?$'

    if [ "$location" = "auto" ]; then
        http_get "https://ipwho.is/" |
            jq -r 'select(.success == true) | "\(.latitude) \(.longitude)"' |
            grep -E "$COORD_RE" | head -n 1
        return
    fi

    local name extras
    name=$(echo "$location" | cut -d',' -f1 | sed 's/^ *//;s/ *$//')
    extras=$(echo "$location" | cut -s -d',' -f2- | sed 's/^ *//;s/ *, */,/g;s/ *$//')

    http_get "https://geocoding-api.open-meteo.com/v1/search?count=20&format=json&name=$(jq -rn --arg n "$name" '$n|@uri')" |
        jq -r --arg extras "$extras" '
            ($extras | ascii_downcase | split(",") | map(select(. != ""))) as $tokens
            | (.results // [])
            | map(select(. as $r | all($tokens[];
                . as $t | [($r.admin1 // ""), ($r.country // ""), ($r.country_code // "")]
                | map(ascii_downcase) | index($t) != null)))
            | (.[0] // empty)
            | "\(.latitude) \(.longitude)"' |
        grep -E "$COORD_RE" | head -n 1
}

# see https://open-meteo.com/en/docs
wmo_to_cond()
{
    case "$1" in
    0 | 1) cond="clear" ;;
    2) cond="partly" ;;
    3) cond="overcast" ;;
    45 | 48) cond="fog" ;;
    51 | 53 | 55 | 56 | 57) cond="drizzle" ;;
    61 | 63 | 65 | 66 | 67) cond="rain" ;;
    71 | 73 | 75 | 77 | 85 | 86) cond="snow" ;;
    80 | 81 | 82) cond="showers" ;;
    95 | 96 | 97 | 99) cond="thunder" ;;
    *) cond="unknown" ;;
    esac
}

# see https://open-meteo.com/en/docs
wmo_description()
{
    case "$1" in
    0) echo "Clear sky" ;;
    1) echo "Mainly clear" ;;
    2) echo "Partly cloudy" ;;
    3) echo "Overcast" ;;
    45) echo "Fog" ;;
    48) echo "Depositing rime fog" ;;
    51) echo "Light drizzle" ;;
    53) echo "Moderate drizzle" ;;
    55) echo "Dense drizzle" ;;
    56) echo "Light freezing drizzle" ;;
    57) echo "Dense freezing drizzle" ;;
    61) echo "Slight rain" ;;
    63) echo "Moderate rain" ;;
    65) echo "Heavy rain" ;;
    66) echo "Light freezing rain" ;;
    67) echo "Heavy freezing rain" ;;
    71) echo "Slight snowfall" ;;
    73) echo "Moderate snowfall" ;;
    75) echo "Heavy snowfall" ;;
    77) echo "Snow grains" ;;
    80) echo "Slight rain showers" ;;
    81) echo "Moderate rain showers" ;;
    82) echo "Violent rain showers" ;;
    85) echo "Slight snow showers" ;;
    86) echo "Heavy snow showers" ;;
    95) echo "Thunderstorm" ;;
    96) echo "Thunderstorm with slight hail" ;;
    97) echo "Heavy thunderstorm" ;;
    99) echo "Thunderstorm with heavy hail" ;;
    *) echo "unknown" ;;
    esac
}

provider_open_meteo()
{
    local data code
    data=$(http_get "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,apparent_temperature,relative_humidity_2m,pressure_msl,wind_speed_10m,cloud_cover,weather_code,is_day&daily=temperature_2m_max,temperature_2m_min&forecast_days=1&timezone=auto&wind_speed_unit=ms") || return 1
    echo "$data" | jq -e '.current' >/dev/null 2>&1 || return 1

    temp=$(echo "$data" | jq -r '.current.temperature_2m')
    temp_feels_like=$(echo "$data" | jq -r '.current.apparent_temperature')
    humidity=$(echo "$data" | jq -r '.current.relative_humidity_2m')
    pressure=$(echo "$data" | jq -r '.current.pressure_msl')
    wind_speed=$(echo "$data" | jq -r '.current.wind_speed_10m')
    cloudiness=$(echo "$data" | jq -r '.current.cloud_cover')
    is_day=$(echo "$data" | jq -r '.current.is_day')
    temp_min=$(echo "$data" | jq -r '.daily.temperature_2m_min[0]')
    temp_max=$(echo "$data" | jq -r '.daily.temperature_2m_max[0]')
    code=$(echo "$data" | jq -r '.current.weather_code')
    description=$(wmo_description "$code")
    wmo_to_cond "$code"
}

provider_brightsky()
{
    local cur day icon
    cur=$(http_get "https://api.brightsky.dev/current_weather?lat=$lat&lon=$lon") || return 1
    echo "$cur" | jq -e '.weather' >/dev/null 2>&1 || return 1

    temp=$(echo "$cur" | jq -r '.weather.temperature')
    pressure=$(echo "$cur" | jq -r '.weather.pressure_msl')
    humidity=$(echo "$cur" | jq -r '.weather.relative_humidity')
    # Bright Sky reports wind in km/h -> convert to m/s
    wind_speed=$(echo "$cur" | jq -r '(.weather.wind_speed_10 // .weather.wind_speed // null) | if . == null then "" else (. / 3.6) end')
    cloudiness=$(echo "$cur" | jq -r '.weather.cloud_cover')
    temp_feels_like="" # not provided by Bright Sky
    icon=$(echo "$cur" | jq -r '.weather.icon // "unknown"')
    description=$(echo "$cur" | jq -r '.weather.condition // .weather.icon // "unknown"')

    case "$icon" in
    *night) is_day=0 ;;
    *) is_day=1 ;;
    esac
    case "$icon" in
    clear-*) cond="clear" ;;
    partly-cloudy-*) cond="partly" ;;
    cloudy) cond="overcast" ;;
    fog) cond="fog" ;;
    rain) cond="rain" ;;
    sleet) cond="sleet" ;;
    snow | hail) cond="snow" ;;
    thunderstorm) cond="thunder" ;;
    *) cond="unknown" ;;
    esac

    local next tz
    day=$(date +%F)
    next=$(date -d "$day + 1 day" +%F 2>/dev/null)
    tz="${TZ:-$(readlink /etc/localtime 2>/dev/null | sed 's|.*/zoneinfo/||')}"
    [ -z "$tz" ] && tz="UTC"
    read -r temp_min temp_max < <(http_get "https://api.brightsky.dev/weather?lat=$lat&lon=$lon&date=$day&last_date=$next&tz=$tz" |
        jq -r --arg day "$day" '[.weather[] | select(.timestamp[:10] == $day) | .temperature | select(. != null)]
            | if length > 0 then "\(min) \(max)" else "null null" end')
}

icon_for()
{
    if [ "$is_day" = "0" ]; then
        case "$cond" in
        clear) echo " " ;;
        partly) echo " " ;;
        cloudy | overcast) echo " " ;;
        fog) echo " " ;;
        drizzle | rain | showers) echo " " ;;
        thunder) echo " " ;;
        snow | sleet) echo " " ;;
        *) echo " " ;;
        esac
    else
        case "$cond" in
        clear) echo " " ;;
        partly) echo " " ;;
        cloudy | overcast) echo " " ;;
        fog) echo " " ;;
        drizzle | rain | showers) echo " " ;;
        thunder) echo " " ;;
        snow | sleet) echo " " ;;
        *) echo " " ;;
        esac
    fi
}

weather()
{
    require curl jq
    load_config
    [ -n "$1" ] && {
        valid_provider "$1" || die "unknown provider '$1' (available: $PROVIDERS)"
        provider="$1"
    }

    local cords
    cords=$(get_coordinates)
    if [ -z "$cords" ] || echo "$cords" | grep -q "^null"; then
        die "Could not get coordinates for location $location"
    fi
    read -r lat lon <<<"$cords"

    description="" temp="" temp_min="" temp_max="" temp_feels_like=""
    pressure="" humidity="" wind_speed="" cloudiness="" cond="unknown" is_day=1

    case "$provider" in
    open-meteo) provider_open_meteo ;;
    brightsky) provider_brightsky ;;
    esac || die "Could not get weather for location $location from provider $provider"

    [ -z "$temp" ] || [ "$temp" = "null" ] && die "Provider $provider returned no data for $location"

    # feels-like falls back to the actual temperature in the headline
    local headline_feels="$temp_feels_like"
    [ -z "$headline_feels" ] || [ "$headline_feels" = "null" ] && headline_feels="$temp"

    printf "%s %s(%s)°C\n\n" "$(icon_for)" "$(format_val "$temp")" "$(format_val "$headline_feels")"
    printf "provider:        %s\n" "$provider"
    printf "weather:         %s\n" "$description"
    printf "temp:            %s°C\n" "$(format_val "$temp")"
    printf "temp feels like: %s°C\n" "$(format_val "$temp_feels_like")"
    printf "temp min:        %s°C\n" "$(format_val "$temp_min")"
    printf "temp max:        %s°C\n" "$(format_val "$temp_max")"
    printf "pressure:        %s hPa\n" "$(format_val "$pressure")"
    printf "humidity:        %s%%\n" "$(format_val "$humidity")"
    printf "wind speed:      %s m/s\n" "$(format_val "$wind_speed")"
    printf "cloudiness:      %s%%\n" "$(format_val "$cloudiness")"
}

usage()
{
    cat <<EOF
Usage: $(basename "$0") [command]

Commands:
  setup                 setup provider and location
  weather [provider]    show weather (optionally override the provider once)
  provider [name]       list providers, or switch to [name]
  help                  show this help

Providers: $PROVIDERS
EOF
}

case "$1" in
setup) setup ;;
weather) weather "$2" ;;
provider | providers) provider_cmd "$2" ;;
help | -h | --help) usage ;;
*) weather ;;
esac
