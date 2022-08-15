#!/bin/sh
gpuT=$(nvidia-smi --format=csv,noheader --query-gpu=temperature.gpu)
gpuU=$(nvidia-smi --format=csv,noheader,nounits --query-gpu=utilization.gpu)

#if (( $(echo "$gpuU <= 33" | bc -l) )); then
#	gpuU=^c\#10a204^$gpuU^d^
#elif (( $(echo "$gpuU > 33" | bc -l) && $(echo "$gpuU <= 66" | bc -l) )); then
#	gpuU=^c\#fded02^$gpuU^d^
#elif (( $(echo "$gpuU > 66" | bc -l) )); then
#	gpuU=^c\#d80404^$gpuU^d^
#fi

#if (( $(echo "$gpuT <= 60" | bc -l) )); then
#	gpuT=^c\#10a204^$gpuT^d^
#elif (( $(echo "$gpuT > 60" | bc -l) && $(echo "$gpuT <= 80" | bc -l) )); then
#	gpuT=^c\#fded02^$gpuT^d^
#elif (( $(echo "$gpuT > 80" | bc -l) )); then
#	gpuT=^c\#d80404^$gpuT^d^
#fi

echo "$gpuU"% "$gpuT"°C
