#!/bin/bash 

option_desktop() {
    DESKTOP=$(monolog --title "DESKTOP" \
            --extra-button --extra-label "MAP" \
            --menu  "Choose what base of desktop environment would you like:" 10 45 0 \
            "none" "" "hyprland" "WAYLAND WM" "river" "WAYLAND WM"\
	    "sway" "WAYLAND WM" "mangowc" "WAYLAND WM (AUR)" "niri" "WAYLAND SWM" "kde" "WAYLAND/XORG DE" "xfce" "WAYLAND/XORG DE"\
            "bspwm" "XORG WM" "i3" "XORG WM")

            [ "$?" == "3" ] && map

    if [ "$DESKTOP" != "none" ]
    then
            option_login
    fi

        option_modules
}
