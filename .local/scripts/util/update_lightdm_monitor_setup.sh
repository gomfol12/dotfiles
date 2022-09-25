#!/bin/bash
if [ "$UID" -ne 0 ]; then
    echo "scipt must be run as the root user"
    exit 1
fi

if [ -z "$PRIMARY" ]; then
    echo "PRIMARY env variable not set!"
    exit 1
fi

if [ "$(hostname)" = "$HOSTNAME_DESKTOP" ]; then
    cat <<EOF >/etc/lightdm/setupMonitors.sh
xrandr \
    --output "$PRIMARY" --mode 1920x1080 --rate 144 --primary \
    --output "$SECONDARY" --mode 1920x1080 --rate 60 --left-of "$PRIMARY"
nvidia-settings --assign CurrentMetaMode="DPY-0: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}, DPY-1: 1920x1080_144 @1920x1080 +1920+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}" >/dev/null 2>&1
EOF
    chmod +x /etc/lightdm/setupMonitors.sh
    sed -i "/display-setup-script=/s/^#//g" /etc/lightdm/lightdm.conf
    sed -i "/display-setup-script=.*/s/.*/\/etc\/lightdm\/setupMonitors.sh/g" /etc/lightdm/lightdm.conf
    exit
fi

if [ "$(hostname)" = "$HOSTNAME_LAPTOP" ]; then
    cat <<EOF >/etc/lightdm/setupMonitors.sh
xrandr --output "$PRIMARY" --mode 1920x1080 --rate 60 --primary
EOF
    chmod +x /etc/lightdm/setupMonitors.sh
    sed -i "/display-setup-script=/s/^#//g" /etc/lightdm/lightdm.conf
    sed -i "/display-setup-script=.*/s/.*/\/etc\/lightdm\/setupMonitors.sh/g" /etc/lightdm/lightdm.conf
    exit
fi

if [ "$(systemd-detect-virt)" = "kvm" ]; then
    cat <<EOF >/etc/lightdm/setupMonitors.sh
xrandr --output "$PRIMARY" --mode 1920x1080 --rate 60 --primary
EOF
    chmod +x /etc/lightdm/setupMonitors.sh
    sed -i "/display-setup-script=/s/^#//g" /etc/lightdm/lightdm.conf
    sed -i "/display-setup-script=.*/s/.*/\/etc\/lightdm\/setupMonitors.sh/g" /etc/lightdm/lightdm.conf
    exit
fi
