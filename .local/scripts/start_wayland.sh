#!/bin/sh

if test "$NVIDIA"; then
    # Nvidia
    export LIBVA_DRIVER_NAME=nvidia
    export XDG_SESSION_TYPE=wayland
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
fi

export WLR_NO_HARDWARE_CURSORS=1
export MOZ_ENABLE_WAYLAND=1 # firefox wayland
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=24

export WLR_DRM_NO_ATOMIC=1 # remove in the future (tearing)

if [ "$1" = "dwl" ]; then
    exec ~/.local/src/dwl/dwl
else
    exec Hyprland
fi
