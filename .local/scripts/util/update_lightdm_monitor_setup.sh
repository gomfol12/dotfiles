#!/bin/bash
ask_exit()
{
    echo
    read -p "cancel? (y/n): " -r ask_exit
    if [[ "$ask_exit" =~ [yY] ]]; then
        exit
    fi
}
trap "ask_exit" INT TERM

if [ -z "$PRIMARY" ]; then
    echo "PRIMARY env variable not set!"
    while read -p "set PRIMARY to: " -r PRIMARY; do
        if [ -n "$PRIMARY" ]; then
            break
        fi
        echo "Invalid option! Try again."
    done
fi

file=$(mktemp)

if [ "$(hostname)" = "$HOSTNAME_DESKTOP" ]; then
    cat <<EOF >"$file"
xrandr \
    --output "$PRIMARY" --mode 1920x1080 --rate 144 --primary \
    --output "$SECONDARY" --mode 1920x1080 --rate 60 --left-of "$PRIMARY"
nvidia-settings --assign CurrentMetaMode="DPY-0: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}, DPY-1: 1920x1080_144 @1920x1080 +1920+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}" >/dev/null 2>&1
EOF
fi
if [ "$(hostname)" = "$HOSTNAME_LAPTOP" ]; then
    cat <<EOF >"$file"
xrandr --output "$PRIMARY" --mode 2256x1504 --rate 60 --primary
EOF
fi
if [ "$(systemd-detect-virt)" = "kvm" ]; then
    cat <<EOF >"$file"
xrandr --output "$PRIMARY" --mode 1920x1080 --rate 60 --primary
EOF
fi

su root -c 'dd if='"$file"' of=/etc/lightdm/setupMonitors.sh;
chmod +x /etc/lightdm/setupMonitors.sh;
sed -i "/display-setup-script=/s/^#//g" /etc/lightdm/lightdm.conf;
sed -i "/display-setup-script=.*/s/=.*/=\/etc\/lightdm\/setupMonitors.sh/g" /etc/lightdm/lightdm.conf;'

rm -rf "$file"
