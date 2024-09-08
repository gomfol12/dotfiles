#!/bin/sh

nvidia-smi --format=csv,noheader,nounits --query-gpu=utilization.gpu,temperature.gpu | awk -F',' '{print $1"%"$2"°C"}'
