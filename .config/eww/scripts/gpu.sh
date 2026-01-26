#!/bin/sh

if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --format=csv,noheader,nounits --query-gpu=utilization.gpu,temperature.gpu | awk -F',' '{print $1"%"$2"°C"}'
else
    echo "-1% -1°C"
fi
