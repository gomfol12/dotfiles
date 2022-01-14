#!/bin/sh
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar primary & echo $! > /tmp/polybar_primary_pid
polybar secound & echo $! > /tmp/polybar_secondary_pid
