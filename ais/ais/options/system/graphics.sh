#!/bin/bash

option_graphics() {

    GRAPHICS=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "For nvidia choose only 1 option (nvidia-$ or nouveau)\nFor hybrid graphics you can choose 1 nvidia and other ex. (intel + nvidia-470)" 0 0 \
      --and-widget \
    --title "GRAPHICS" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --checklist  "Choose your graphics drivers:" 0 0 0 \
    "nvidia-open" "Proprietary" "off" \
    "amd" "" "off" \
    "intel" "" "off" "nouveau" "" "off" \
    "nvidia-580" "Legacy" "off" "nvidia-470" "Legacy" "off" "nvidia-390" "Legacy" "off"
    )

        [ "$?" == "3" ] && map

        option_desktop
}
