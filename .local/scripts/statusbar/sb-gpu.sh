#!/bin/sh
gpuT=$(nvidia-smi --format=csv,noheader --query-gpu=temperature.gpu)
gpuU=$(nvidia-smi --format=csv,noheader,nounits --query-gpu=utilization.gpu)

echo "$gpuU"% "$gpuT"°C
