#!/bin/bash
interface=enp37s0

R1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
T1=$(cat /sys/class/net/$interface/statistics/tx_bytes)

sleep 1

R2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
T2=$(cat /sys/class/net/$interface/statistics/tx_bytes)

RBPS=$(("$R2" - "$R1"))
TBPS=$(("$T2" - "$T1"))

RD="$(("$RBPS" / 1024))KB/s"
TD="$(("$TBPS" / 1024))KB/s"

(("$RBPS" / 1024 > 1024)) && RD="$(echo "$RBPS / 1024 / 1024" | bc -l | awk '{printf "%.2f", $1}')MB/s"
(("$TBPS" / 1024 > 1024)) && TD="$(echo "$TBPS / 1024 / 1024" | bc -l | awk '{printf "%.2f", $1}')MB/s"

[ "$(cat /sys/class/net/$interface/operstate)" = "up" ] && echo " $RD 祝 $TD" || echo "not connected"

#echo $icon $(vnstat -tr 2 | tail -3 | head -2 | tr -d "\n" | awk '{printf "%.2f%s 祝%.2f%s", $2/8, substr($3,1,2), $7/8, substr($8,1,2) }')
