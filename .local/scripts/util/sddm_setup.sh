#!/bin/bash

set -e

pacman_dep_check()
{
    pacman -Q "$1" >/dev/null 2>&1 || {
        echo "$1 is not installed"
        exit 1
    }
}
pacman_dep_check "sddm-git"
pacman_dep_check "sddm-theme-corners-git"

if [ "$UID" -ne 0 ]; then
    echo "scipt must be run as the root user"
    exit 1
fi

log_high()
{
    printf "\033[1m%s\033[0m\n" "$1"
}

get_color()
{
    xrdb -query | grep "$1:" | cut -f2 | head -n 1
}

sddm_config_setup()
{
    # config
    mkdir -p /etc/sddm.conf.d
    cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf.d/sddm.conf
}

sed_option()
{
    local option="$1"
    local value="$2"
    local file="$3"

    sed -i "s@^$option=.*@$option=$value@" "$file"
}

sddm_monitor_setup()
{
    # monitor setup
    if [ -z "$PRIMARY" ]; then
        echo "PRIMARY env variable not set!"
        exit 1
    fi

    if grep -q "# setup monitors" "/usr/share/sddm/scripts/Xsetup"; then
        sed -i '/# setup monitors/,+3d' "/usr/share/sddm/scripts/Xsetup"
    fi

    if [ "$(hostname)" = "$HOSTNAME_DESKTOP" ]; then
        echo "\
# setup monitors
xrandr \\
    --output \"$PRIMARY\" --mode 1920x1080 --rate 144 --primary \\
    --output \"$SECONDARY\" --mode 1920x1080 --rate 60 --left-of \"$PRIMARY\"
nvidia-settings --assign CurrentMetaMode=\"DPY-0: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}, DPY-1: 1920x1080_144 @1920x1080 +1920+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}\" >/dev/null 2>&1" >>"/usr/share/sddm/scripts/Xsetup"
    fi
    if [ "$(hostname)" = "$HOSTNAME_LAPTOP" ]; then
        echo "\
# setup monitors
xrandr --output \"$PRIMARY\" --mode 2256x1504 --rate 60 --primary" >>"/usr/share/sddm/scripts/Xsetup"
    fi
    if [ "$(systemd-detect-virt)" = "kvm" ]; then
        echo "\
# setup monitors
xrandr --output \"$PRIMARY\" --mode 1920x1080 --rate 60 --primary" >>"/usr/share/sddm/scripts/Xsetup"
    fi
}

sddm_theme_setup()
{
    local wallpaper_path
    wallpaper_path=$1

    if [ -z "$wallpaper_path" ]; then
        local username

        username=$(who | grep -E "tty[[:digit:]]+" | cut -d' ' -f1)
        if [ "$(echo "$username" | wc -l)" -gt 1 ]; then
            echo "multiple users logged in"
            exit 1
        fi

        wallpaper_path=$(readlink -f "/home/$username/.local/share/bg")
    else
        wallpaper_path=$(readlink -f "$1")
    fi

    extension="${wallpaper_path##*.}"

    sed_option "Current" "corners" "/etc/sddm.conf.d/sddm.conf"

    cp "$wallpaper_path" "/usr/share/sddm/themes/corners/backgrounds/wallpaper.$extension"

    sed_option "BgSource" "\"backgrounds/wallpaper.$extension\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "FontFamily" "\"Inconsolata\"" "/usr/share/sddm/themes/corners/theme.conf"

    if [ "$(hostname)" = "$HOSTNAME_LAPTOP" ]; then
        sed_option "FontSize" "24" "/usr/share/sddm/themes/corners/theme.conf"
    else
        sed_option "FontSize" "12" "/usr/share/sddm/themes/corners/theme.conf"
    fi

    sed_option "UserPictureEnabled" "false" "/usr/share/sddm/themes/corners/theme.conf"

    color0=$(get_color "color0")
    color1=$(get_color "color1")
    color7=$(get_color "color7")

    sed_option "UserBorderColor" "\"$color1\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "UserColor" "\"$color7\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "InputColor" "\"$color0\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "InputTextColor" "\"$color7\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "InputBorderColor" "\"$color1\"" "/usr/share/sddm/themes/corners/theme.conf"

    sed_option "LoginButtonTextColor" "\"$color0\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "LoginButtonColor" "\"$color1\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "PopupColor" "\"$color1\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "PopupActiveColor" "\"$color0\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "PopupActiveTextColor" "\"$color7\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "SessionButtonColor" "\"$color0\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "SessionIconColor" "\"$color1\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "PowerButtonColor" "\"$color0\"" "/usr/share/sddm/themes/corners/theme.conf"
    sed_option "PowerIconColor" "\"$color1\"" "/usr/share/sddm/themes/corners/theme.conf"

    sed_option "DateTimeSpacing" "-5" "/usr/share/sddm/themes/corners/theme.conf"

    sed_option "DateColor" "\"$color0\"" "/usr/share/sddm/themes/corners/theme.conf"

    sed_option "DateFormat" "\"dddd, d MMMM\"" "/usr/share/sddm/themes/corners/theme.conf"

    sed_option "TimeColor" "\"$color0\"" "/usr/share/sddm/themes/corners/theme.conf"

    sed_option "TimeFormat" "\"hh:mm\"" "/usr/share/sddm/themes/corners/theme.conf"
}

if [ ! -f "/etc/sddm.conf.d/sddm.conf" ]; then
    sddm_config_setup
fi

if ! grep -q "# setup monitors" "/usr/share/sddm/scripts/Xsetup"; then
    sddm_monitor_setup
fi

sddm_theme_setup "$1"
