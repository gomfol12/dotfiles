#!/bin/sh

interval=$1

if [ -z "$interval" ]; then
    interval=5
fi

cpuT=$(sensors | awk '/^Tdie:/ {printf "%d", $2}')
cpu_stat_1=$(grep 'cpu ' /proc/stat)

echo "0% 0°C"

while true; do
    sleep "$interval"

    cpuT=$(sensors | awk '/^Tdie:/ {printf "%d", $2}')
    cpu_stat_2=$(grep 'cpu ' /proc/stat)
    cpuU=$(echo "$cpu_stat_1 $cpu_stat_2" | awk -v RS="" '{printf "%.f", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')
    echo "$cpuU"% "$cpuT"°C

    cpu_stat_1=$cpu_stat_2
done
