#!/bin/bash
interface=enp37s0

interval=$1

if [ -z "$interval" ]; then
    interval=5
fi

R1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
T1=$(cat /sys/class/net/$interface/statistics/tx_bytes)

[ "$(cat /sys/class/net/$interface/operstate)" = "up" ] && echo "󰇚 0 MiB/s 󰕒 0 MiB/s" || echo "not connected"

while true; do
    sleep "$interval"

    R2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    T2=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    RBPS=$(("$R2" - "$R1"))
    TBPS=$(("$T2" - "$T1"))
    RD="$(echo "$RBPS" | awk '{printf "%.2f", $1 / 1024 / 1024}') MiB/s"
    TD="$(echo "$TBPS" | awk '{printf "%.2f", $1 / 1024 / 1024}') MiB/s"
    [ "$(cat /sys/class/net/$interface/operstate)" = "up" ] && echo "󰇚 $RD 󰕒 $TD" || echo "not connected"

    R1=$R2
    T1=$T2
done
