setxkbmap -layout "us, de(nodeadkeys)" -option "caps:ctrl_modifier, grp:win_space_toggle, grp_led:caps"
xinput set-prop 'Sharkoon Technologies SKILLER SGM1' 'libinput Accel Speed' -1
xinput set-prop 'Sharkoon Technologies SKILLER SGM1' 'libinput Accel Profile Enabled' 0, 0

(sleep 15 && \
 xset r rate 200 40 && \
 xset dpms 300 300 600 && \
 xset s 300) &
xss-lock -- slockrun.sh &

imwheel -b 45 &
xrdb ~/.config/Xresources &
dunst &
nitrogen --restore &
picom &
sxhkd &
dwmblocks &
numlockx &
unclutter --timeout 5 &
lxpolkit &
#keynav &
clipmenud &

exec bspwm
