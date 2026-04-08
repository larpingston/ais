#!/bin/bash

apply_dialog_theme() {
    local dialogrc="/tmp/ais-dialogrc"
    cat > "$dialogrc" << 'EOF'
use_shadow = OFF
use_colors = ON
screen_color = (BLACK,BLACK,OFF)
shadow_color = (BLACK,BLACK,OFF)
dialog_color = (WHITE,BLACK,OFF)
title_color = (RED,BLACK,ON)
border_color = (RED,BLACK,OFF)
button_active_color = (BLACK,RED,OFF)
button_inactive_color = (WHITE,BLACK,OFF)
button_key_active_color = (BLACK,RED,OFF)
button_key_inactive_color = (WHITE,BLACK,OFF)
button_label_active_color = (BLACK,RED,OFF)
button_label_inactive_color = (WHITE,BLACK,OFF)
inputbox_color = (WHITE,BLACK,OFF)
inputbox_border_color = (RED,BLACK,OFF)
searchbox_color = (WHITE,BLACK,OFF)
searchbox_title_color = (RED,BLACK,ON)
searchbox_border_color = (RED,BLACK,OFF)
position_indicator_color = (RED,BLACK,OFF)
menubox_color = (WHITE,BLACK,OFF)
menubox_border_color = (RED,BLACK,OFF)
item_color = (WHITE,BLACK,OFF)
item_selected_color = (BLACK,RED,OFF)
tag_color = (WHITE,BLACK,OFF)
tag_selected_color = (BLACK,RED,OFF)
tag_key_color = (RED,BLACK,ON)
tag_key_selected_color = (BLACK,RED,OFF)
check_color = (WHITE,BLACK,OFF)
check_selected_color = (BLACK,RED,OFF)
uarrow_color = (WHITE,BLACK,OFF)
darrow_color = (WHITE,BLACK,OFF)
itemhelp_color = (WHITE,BLACK,OFF)
form_active_text_color = (WHITE,BLACK,OFF)
form_text_color = (WHITE,BLACK,OFF)
form_item_readonly_color = (RED,BLACK,ON)
gauge_color = (RED,BLACK,OFF)
border2_color = (RED,BLACK,OFF)
inputbox_border2_color = (RED,BLACK,OFF)
menubox_border2_color = (RED,BLACK,OFF)
searchbox_border2_color = (RED,BLACK,OFF)
EOF
    export DIALOGRC="$dialogrc"
}

apply_default_theme() {
    # Keep terminal palette untouched for consistent dialog rendering.
    true
}

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
        wal -q --theme "$THEME"
    else
        [ "$?" == "3" ] && option_disk 
    fi
        option_theme
}
