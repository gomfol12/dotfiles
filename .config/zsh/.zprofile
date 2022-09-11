#!/bin/zsh
if [[ "$(tty)" = "/dev/tty1" ]]; then
    pgrep awesome || startx "$XINITRC"
fi
