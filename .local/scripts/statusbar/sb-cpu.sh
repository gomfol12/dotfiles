#!/bin/bash
cpuT=$(sensors | awk '/^Tdie:/ {printf "%d", $2}')
#cpuU=$(cat /proc/loadavg | awk '{printf "%d", $1 * 8.34}')

cpuU=$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{printf "%.f", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')

#if (( $(echo "$cpuU <= 33" | bc -l) )); then
#	cpuU=^c\#10a204^$cpuU^d^
#elif (( $(echo "$cpuU > 33" | bc -l) && $(echo "$cpuU <= 66" | bc -l) )); then
#	cpuU=^c\#fded02^$cpuU^d^
#elif (( $(echo "$cpuU > 66" | bc -l) )); then
#	cpuU=^c\#d80404^$cpuU^d^
#fi


#if (( $(echo "$cpuT <= 60" | bc -l) )); then
#	cpuT=^c\#10a204^$cpuT^d^
#elif (( $(echo "$cpuT > 60" | bc -l) && $(echo "$cpuT <= 80" | bc -l) )); then
#	cpuT=^c\#fded02^$cpuT^d^
#elif (( $(echo "$cpuT > 80" | bc -l) )); then
#	cpuT=^c\#d80404^$cpuT^d^
#fi

echo "$cpuU"% "$cpuT"°C

#ps axch -o cmd:15,%mem --sort=-%mem | head
#ps axch -o cmd:15,%cpu --sort=-%cpu | head

#cpuU=$(mpstat | awk '/^Average:/ {print 100-$12}')

#cache=/tmp/cpuU
#stats=$(awk '/cpu / {printf "%d %d\n", ($2 + $3 + $4 + $5), $5 }' /proc/stat)

#[ ! -f $cache ] && echo "$stats" > "$cache"
#old=$(cat "$cache")

#total=${stats%% *}
#idle=${stats##* }

#echo $(echo "$old" | awk '{printf "%f\n", (1 - ((idle - $2) / (total - $1))) * 100}')

#echo "$stats" > "$cache"
