#!/bin/bash

option_aur() {

    AUR=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "It doesn't really matter, most people choose between yay and paru" 0 0 \
      --and-widget \
    --title "AUR" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu  "Select your AUR helper:" 0 0 0 \
    "yay" "Written in GO" "paru" "Written in RUST"\
    "trizen" "Written in PERL" "yaourtix" "Artix conitnuer of yaourt" "none" "Written in nothing" \

    )
        [ "$?" == "3" ] && map

        echo 'AUR="$AUR"' >> options/script/variables.sh

        option_kernel
}
