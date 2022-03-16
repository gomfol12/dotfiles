#!/bin/sh

get_color()
{
    xrdb -query | grep "$1:" | cut -f2 | head -n 1
}

color()
{
    get_color "color$1"
}

color_bg()
{
    get_color "background"
}

color_fg()
{
    get_color "foreground"
}

color0=$(color 0)
color1=$(color 1)
color2=$(color 2)
color3=$(color 3)
color4=$(color 4)
color5=$(color 5)
color6=$(color 6)
color7=$(color 7)
color8=$(color 8)
color9=$(color 9)
color10=$(color 10)
color11=$(color 11)
color12=$(color 12)
color13=$(color 13)
color14=$(color 14)
color15=$(color 15)

background=$(color_bg)
foreground=$(color_fg)
