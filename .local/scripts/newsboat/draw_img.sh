#!/bin/sh
if [ -n "$FIFO_UEBERZUG" ]; then
    printf '{"action": "add", "identifier": "preview", "x": %d, "y": %d, "width": %d, "height": %d, "scaler": "contain", "scaling_position_x": 0.5, "scaling_position_y": 0.5, "path": "%s"}\n' \
        "$1" "$2" "$3" "$4" "$5" >"$FIFO_UEBERZUG"
fi
