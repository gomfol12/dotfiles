#!/bin/sh
if [ -n "$FIFO_UEBERZUG" ]; then
    printf '{"action": "remove", "identifier": "preview"}\n' >"$FIFO_UEBERZUG"
elif [ "$TERM" = "xterm-kitty" ]; then
    if ! command -v kitty >/dev/null; then
        printf "kitty not found\n"
        exit 1
    fi
    kitty +kitten icat --clear --stdin no --transfer-mode stream </dev/null >/dev/tty
fi
