#!/bin/bash

SYSTEM_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | tr -d ' ')

FLATPAK_VERSION=$(flatpak list --columns=name | grep -oP 'nvidia-\K[0-9]+-[0-9]+-[0-9]+' | head -n 1 | tr '-' '.')

if ! [[ "$SYSTEM_VERSION" == "$FLATPAK_VERSION" ]]; then
    notify-send "Flatpak / NVIDIA Driver Version Check" "NVIDIA versions differ! System: $SYSTEM_VERSION, Flatpak: $FLATPAK_VERSION"
fi
