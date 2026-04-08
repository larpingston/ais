#!/bin/bash 

option_login() {
    LOGIN=$(monolog --title "LOGIN MANAGER" \
            --extra-button --extra-label "MAP" \
            --menu  "Choose what login manager would you like:" 10 45 0 \
	    "none" "" "sddm" "WAYLAND (gui)" "greetd" "WAYLAND (tui)")

            [ "$?" == "3" ] && map

}
