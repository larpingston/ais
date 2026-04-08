#!/bin/bash

option_lvm() {

    if LVM=$(monolog --begin 5 5 \
    --title "HELPER" \
    --infobox "LVM - Logical Volume Managment: You are operating on logical layouts which are not real like your disk" 0 0 \
    --and-widget \
    --title "LVM" \
    --defaultno \
    --yesno "Would you like LVM?" 0 0 \
    )
    then
        LVM="yes"
    else
        LVM="no"
    fi

        option_swap_style
}
