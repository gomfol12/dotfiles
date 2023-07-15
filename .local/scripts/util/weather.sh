#!/bin/bash

open_weather_map_api_key=""
location=""

format_val()
{
    if [ "$(echo "$1 >= -0.5 && $1 <= 0" | bc)" -ge 1 ]; then
        printf "%.0f" "$(echo "$1 * (($1 > 0) - ($1 < 0))" | bc)"
    else
        printf "%.0f" "$1"
    fi
}

setup()
{
    while read -p "openweathermap.org API key: " -r open_weather_map_api_key; do
        if [ -z "$open_weather_map_api_key" ]; then
            echo "API key cannot be empty"
        else
            break
        fi
    done

    while read -p "Location [(city,state,country)/auto]: " -r location; do
        if [ -z "$location" ]; then
            echo "Location cannot be empty"
        else
            break
        fi
    done

    echo "open_weather_map_api_key=\"$open_weather_map_api_key\"
location=\"$location\"" >"$XDG_CACHE_HOME/weather-info"

    chmod 600 "$XDG_CACHE_HOME/weather-info"
}

weather()
{
    if [ ! -f "$XDG_CACHE_HOME/weather-info" ]; then
        echo "weather-info does not exists. Please run 'weather.sh setup' first"
        exit 1
    fi

    open_weather_map_api_key=$(grep open_weather_map_api_key "$XDG_CACHE_HOME/weather-info" | cut -d'"' -f2)
    location=$(grep location "$XDG_CACHE_HOME/weather-info" | cut -d'"' -f2)

    if [ "$location" = "auto" ]; then
        cords=$(curl -s "http://ip-api.com/json" | jq -r '.lat,.lon')
    else
        cords=$(curl -s "http://api.openweathermap.org/geo/1.0/direct?q=$location&appid=$open_weather_map_api_key" | jq -r '.[0].lat,.[0].lon')
    fi
    if [ -z "$cords" ] || echo "$cords" | grep -q "^null"; then
        echo "Error: Could not get coordinates for location $location"
        exit 1
    fi

    lat=$(echo "$cords" | head -n 1)
    lon=$(echo "$cords" | tail -n 1)

    weather=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$open_weather_map_api_key&units=metric")
    if [ -z "$weather" ] || echo "$weather" | grep -q "^null"; then
        echo "Error: Could not get weather for location $location"
        exit 1
    fi

    weather_description=$(echo "$weather" | jq -r '.weather[0].description')
    temp=$(echo "$weather" | jq -r '.main.temp')
    temp_min=$(echo "$weather" | jq -r '.main.temp_min')
    temp_max=$(echo "$weather" | jq -r '.main.temp_max')
    temp_feels_like=$(echo "$weather" | jq -r '.main.feels_like')
    pressure=$(echo "$weather" | jq -r '.main.pressure')
    humidity=$(echo "$weather" | jq -r '.main.humidity')
    wind_speed=$(echo "$weather" | jq -r '.wind.speed')
    cloudiness=$(echo "$weather" | jq -r '.clouds.all')

    icon_id=$(echo "$weather" | jq -r '.weather[0].icon')
    sunrise=$(echo "$weather" | jq -r '.sys.sunrise')
    sunset=$(echo "$weather" | jq -r '.sys.sunset')

    icon=""

    if [ "$sunrise" -lt "$(date +%s)" ] && [ "$sunset" -gt "$(date +%s)" ]; then
        case "$icon_id" in
        "01d") icon=" " ;; # clear sky day
        "02d") icon=" " ;; # few clouds day
        "03d") icon=" " ;; # scattered clouds day
        "04d") icon=" " ;; # broken clouds day
        "09d") icon=" " ;; # shower rain day
        "10d") icon=" " ;; # rain day
        "11d") icon=" " ;; # thunderstorm day
        "13d") icon=" " ;; # snow day
        "50d") icon=" " ;; # mist day
        *) ;;
        esac
    else
        case "$icon_id" in
        "01n") icon=" " ;; # clear sky night
        "02n") icon=" " ;; # few clouds night
        "03n") icon=" " ;; # scattered clouds night
        "04n") icon=" " ;; # broken clouds night
        "09n") icon=" " ;; # shower rain night
        "10n") icon=" " ;; # rain night
        "11n") icon=" " ;; # thunderstorm night
        "13n") icon=" " ;; # snow night
        "50n") icon=" " ;; # mist night
        *) ;;
        esac
    fi

    printf "%s %.f(%.f)°C

weather:         %s
temp:            %.f°C
temp feels like: %.f°C
temp min:        %.f°C
temp max:        %.f°C
pressure:        %.f hPa
humidity:        %.f%%
wind speed:      %.f m/s
cloudiness:      %.f%%
" "$icon" "$(format_val "$temp")" "$(format_val "$temp_feels_like")" "$weather_description" "$(format_val "$temp")" "$(format_val "$temp_feels_like")" "$(format_val "$temp_min")" "$(format_val "$temp_max")" "$pressure" "$humidity" "$wind_speed" "$cloudiness"
}

case "$1" in
setup) setup ;;
weather) weather ;;
help) echo "Usage: $0 [setup|weather|help]" ;;
*) weather ;;
esac
