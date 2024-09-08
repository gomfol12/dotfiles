#!/bin/bash
interface=enp37s0

R1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
T1=$(cat /sys/class/net/$interface/statistics/tx_bytes)

sleep 1

R2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
T2=$(cat /sys/class/net/$interface/statistics/tx_bytes)

RBPS=$(("$R2" - "$R1"))
TBPS=$(("$T2" - "$T1"))

RD="$(("$RBPS" / 1024))KiB/s"
TD="$(("$TBPS" / 1024))KiB/s"

(("$RBPS" / 1024 > 1024)) && RD="$(echo "$RBPS / 1024 / 1024" | bc -l | awk '{printf "%.2f", $1}')MiB/s"
(("$TBPS" / 1024 > 1024)) && TD="$(echo "$TBPS / 1024 / 1024" | bc -l | awk '{printf "%.2f", $1}')MiB/s"

[ "$(cat /sys/class/net/$interface/operstate)" = "up" ] && echo "󰇚 $RD 󰕒 $TD" || echo "not connected"
