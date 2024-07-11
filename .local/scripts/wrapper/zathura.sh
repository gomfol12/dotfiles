#!/bin/sh

configColorGen()
{
    . "$SCRIPT_DIR/colors.sh"
    cat <<EOF
set recolor "false"
set completion-bg "$background"
set completion-fg "$foreground"
set completion-group-bg "$background"
set completion-group-fg "$color2"
set completion-highlight-bg "$foreground"
set completion-highlight-fg "$background"
set recolor-lightcolor "$background"
set recolor-darkcolor "$foreground"
set default-bg "$background"
set inputbar-bg "$background"
set inputbar-fg "$foreground"
set notification-bg "$background"
set notification-fg "$foreground"
set notification-error-bg "$color1"
set notification-error-fg "$foreground"
set notification-warning-bg "$color1"
set notification-warning-fg "$foreground"
set statusbar-bg "$background"
set statusbar-fg "$foreground"
set index-bg "$background"
set index-fg "$foreground"
set index-active-bg "$foreground"
set index-active-fg "$background"
set render-loading-bg "$background"
set render-loading-fg "$foreground"
EOF
}

zathuraTmpDir=$(mktemp -d)

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zathura/zathurarc" ] && cat "${XDG_CONFIG_HOME:-$HOME/.config}/zathura/zathurarc" >>"$zathuraTmpDir/zathurarc"

configColorGen >>"$zathuraTmpDir/zathurarc"

zathura --config-dir="$zathuraTmpDir" "$@" &
