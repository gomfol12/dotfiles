#!/bin/sh

case $1 in
percent)
    free | awk '/^Mem:/ {printf "%d%%\n", (($3 / $2) * 100) + 0.5, $3 / 1024}'
    ;;
used)
    free | awk '/^Mem:/ {printf "(%d MiB)\n", $3 / 1024}'
    ;;
esac
