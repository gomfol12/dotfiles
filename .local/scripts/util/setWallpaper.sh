#!/bin/bash

# small floating terminal as password prompt. Don't forget to set according rule in your window manager
exec_term()
{
    ${TERMINAL:-st} -n floatterm -g 60x2 -e "$@"
}

bg_path="${XDG_DATA_HOME:-$HOME/.local/share/}/bg"

if [ -f "$1" ]; then
    # generate theme
    theming -i "$1" -r

    exec_term sh -ci "echo Update sddm theme && sudo sddm_setup.sh \"$bg_path\""
elif [ -d "$1" ]; then
    notify-send "Error" "Directory, not a file"
else
    theming -r
fi
