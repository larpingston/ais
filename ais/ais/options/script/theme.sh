#!/bin/bash

option_theme() {

    if THEME=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "If you don't know what to do next, theres button called "NEXT" You have to use right arrow to choose it" 0 0 \
      --and-widget \
      --title "THEMERx1337"\
    --extra-button --extra-label "NEXT"\
    --no-cancel \
    --menu "What theme seems nice for you?" 0 0 0\
    "sexy-gotham" "" "dkeg-transposet" "" "sexy-tangoesque" ""\
    "sexy-s3r0-modified" "" "solarized" "LOL"
    )
    then
        wal -q --theme $THEME
    else
        [ "$?" == "3" ] && option_disk 
    fi
        option_theme
}
