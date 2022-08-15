#!/bin/bash

case "$1" in
"disable_FFCP")
    nvidia-settings --assign CurrentMetaMode="DPY-0: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=Off}, DPY-1: 1920x1080_144 @1920x1080 +1920+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=Off}" >/dev/null 2>&1
    ;;
"enable_FFCP")
    nvidia-settings --assign CurrentMetaMode="DPY-0: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}, DPY-1: 1920x1080_144 @1920x1080 +1920+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}" >/dev/null 2>&1
    ;;
*)
    xrandr \
        --output "$PRIMARY" --mode 1920x1080 --rate 144 --primary \
        --output "$SECONDARY" --mode 1920x1080 --rate 60 --left-of "$PRIMARY"
    nvidia-settings --assign CurrentMetaMode="DPY-0: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}, DPY-1: 1920x1080_144 @1920x1080 +1920+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}" >/dev/null 2>&1
    ;;
esac
