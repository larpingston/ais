#!/bin/bash

option_network() {

    NETWORK=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "Network manager will be good for any kind of network\nIWD is nice for only wifi\ndhcpcd is nice only if you are connecting through ethernet cable" 0 0 \
      --and-widget \
    --title "NETWORK" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu  "Select your Network program:" 0 0 0 \
    "networkmanager" "" "connman" "" "iwd" "" \
    "dhcpcd" "" "none" "" 
    )
        [ "$?" == "3" ] && map

        option_dns
}
