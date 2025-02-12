#!/bin/sh
if [ -n "$FIFO_UEBERZUG" ]; then
    path="$(printf '%s' "$1" | sed 's/\\/\\\\/g;s/"/\\"/g')"
    printf '{"action": "add", "identifier": "preview", "x": %d, "y": %d, "width": %d, "height": %d, "scaler": "contain", "scaling_position_x": 0.5, "scaling_position_y": 0.5, "path": "%s"}\n' \
        "$4" "$5" "$2" "$3" "$1" >"$FIFO_UEBERZUG"
elif [ "$TERM" = "xterm-kitty" ]; then
    if ! command -v kitty >/dev/null; then
        printf "kitty not found\n"
        exit 1
    fi
    kitty +kitten icat --stdin no --transfer-mode stream --place "${2}x${3}@${4}x${5}" "$1" </dev/null >/dev/tty
fi
