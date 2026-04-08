#!/bin/bash

option_swap_style() {

    SWAP_STYLE=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "If you are planning on hibernation use swap partiton\nOtherwise i would use swap file" 0 0 \
      --and-widget \
      --title "SWAP STYLE" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu "How are you swapping?" 0 0 0\
    "file" "" "partition" "" "zram" "" "none" ""
    )
        [ "$?" == "3" ] && map


    if [ "$DISK_METHOD" == "manual" ] && [ "$SWAP_STYLE" == "partition" ] || [ "$SWAP_STYLE" == "none" ]
    then
        option_encryption
    else
        option_swap_size
        option_encryption
    fi
}

option_swap_size() {

    SWAP_SIZE=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "IMPORTANT! You have to write 'NUMBER'G/M example (8G or 500M)\n\nFor swap file do something like 500M\nFor swap partition do x1.5 or x2 of your ram size" 0 0 \
      --and-widget \
    --title "SWAP SIZE" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --inputbox "What size of swap do you want?" 0 0
    )
        [ "$?" == "3" ] && map

        
}
