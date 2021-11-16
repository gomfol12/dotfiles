(sleep 15 && \
 xset r rate 200 40 && \
 xset dpms 300 300 600 && \
 xset s 300) &
xss-lock -- betterlockscreen -l &

imwheel -b "45" &
#xrdb ~/.config/Xresources &
#xmodmap ~/.config/Xmodmap &
dunst &
nitrogen --restore &
picom &
#sxhkd &
#numlockx &
unclutter --timeout 5 &
lxpolkit &
#keynav &
nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings --load-config-only &
clipmanager >&/dev/null &

exec dbus-launch bspwm
