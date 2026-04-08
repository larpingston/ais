#!/bin/bash

option_init() {

    INIT=$(monolog --begin 5 5 \
    --title "HELPER" \
    --infobox "You can choose whatever init you want, no matter what artix iso you are booted in" 0 0 \
    --and-widget \
    --title "INIT" \
    --extra-button --extra-label "MAP" \
    --nocancel \
    --menu "Choose what init are you feeling:" 0 0 0 \
    "dinit" "" "runit" "" "openrc" "" "s6" ""
    )
        [ "$?" == "3" ] && map


        option_hostname
}
