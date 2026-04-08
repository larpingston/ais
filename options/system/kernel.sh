#!/bin/bash

option_kernel() {

    KERNEL=$(monolog --title "KERNEL" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu  "Select your Linux Kernel:" 0 0 0 \
    "linux" "" "linux-lts" "" "linux-zen" ""
    )
        [ "$?" == "3" ] && map

        option_shell
}