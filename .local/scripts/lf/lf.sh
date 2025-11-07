#!/bin/sh
set -e

if [ -n "$DISPLAY" ]; then
    if ! [ "$TERM" = "xterm-kitty" ]; then
        if ! command -v ueberzug >/dev/null; then
            printf "ueberzug not found\n"
            exit 1
        fi

        export FIFO_UEBERZUG="${TMPDIR:-/tmp}/lf-ueberzug-$$"

        cleanup()
        {
            exec 3>&-
            rm "$FIFO_UEBERZUG"
        }

        mkfifo "$FIFO_UEBERZUG"
        ueberzug layer -s <"$FIFO_UEBERZUG" &
        exec 3>"$FIFO_UEBERZUG"
        trap cleanup EXIT
    fi

    if ! [ -d "$HOME/.cache/lf" ]; then
        mkdir -p "$HOME/.cache/lf"
    fi

    exec lf "$@" 3>&-
else
    exec lf "$@"
fi
