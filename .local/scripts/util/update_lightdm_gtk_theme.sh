#!/bin/bash
if [ "$UID" -ne 0 ]; then
    echo "scipt must be run as the root user"
    exit 1
fi

theme_name="oomox-xresources-reverse"
icon_theme_name="oomox-xresources-reverse-flat"
username=marek

cp -rf "/home/$username/.local/share/themes/$theme_name" /usr/share/themes/
cp -rf "/home/$username/.local/share/icons/$icon_theme_name" /usr/share/themes/
cp -rf "/home/$username/.local/share/bg" "/etc/lightdm/wallpaper.png"
