#!/bin/sh

. "${HOME}/.cache/wal/colors.sh"

xrdb -merge "$HOME/.config/Xresources"
xrdb -merge "$HOME/.cache/wal/colors.Xresources"

# restart polybar
start_polybar.sh &
wait $!

# reload bspwm colors
bspc config normal_border_color "$color8"
bspc config active_border_color "$color8"
bspc config focused_border_color "$color1"
bspc config presel_feedback_color "$color1"

# reload discord
#pywal-discord

# regenerate gtk theme
/opt/oomox/plugins/theme_oomox/change_color.sh ~/.local/scripts/xresources_gtk -t ~/.local/share/themes

# spotify
if [ "$(pgrep "spotify")" ]; then
    spicetify update
    spicetify restart
fi

# reload st colors
pidof st | xargs -r kill -SIGUSR1
