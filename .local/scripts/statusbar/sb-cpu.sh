#!/bin/bash
cpuT=$(sensors | awk '/^Tdie:/ {printf "%d", $2}')
cpuU=$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{printf "%.f", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')

echo "$cpuU"% "$cpuT"°C
