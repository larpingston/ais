#!/bin/bash

option_shell() {

    SSHELL=$(monolog --title "SHELL" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu  "Select your user shell:" 0 0 0 \
    "bash" "" "zsh" "" \
    )
        [ "$?" == "3" ] && map

        SSHELL_CONFIG="/home/$USERNAME/."$SSHELL"rc "

        option_network
}
