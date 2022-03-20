#!/bin/sh

# get values form Xresources
. "$HOME/.local/scripts/colors.sh"

dunstTmpFile=$(mktemp)

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dunst/dunstrc" ] && cat "${XDG_CONFIG_HOME:-$HOME/.config}/dunst/dunstrc" >>"$dunstTmpFile"

sed -i "s/frame_color.*=.*\"#.*\"/frame_color = \"$color1\"/" "$dunstTmpFile"
sed -i "s/background.*=.*\"#.*\"/background = \"$background\"/" "$dunstTmpFile"
sed -i "s/foreground.*=.*\"#.*\"/foreground = \"$color7\"/" "$dunstTmpFile"

if pgrep -u "$(id -u)" -nf "^/usr/bin/dunst$"; then
    killall dunst
fi

dunst -config "$dunstTmpFile" "$@"
