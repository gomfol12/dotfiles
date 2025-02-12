#!/bin/sh
if [ -n "$FIFO_UEBERZUG" ]; then
    printf '{"action": "remove", "identifier": "preview"}\n' >"$FIFO_UEBERZUG"
elif [ "$TERM" = "xterm-kitty" ]; then
    kitty +kitten icat --clear --stdin no --transfer-mode stream </dev/null >/dev/tty
fi
