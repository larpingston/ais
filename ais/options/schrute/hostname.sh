#!/bin/bash

option_hostname() {

    HOSTNAME=$(monolog --title "HOSTNAME" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --inputbox "What would you like to name this pc?" 0 0
    )
        [ "$?" == "3" ] && map

        option_root_password
}
