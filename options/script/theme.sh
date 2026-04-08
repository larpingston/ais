#!/bin/bash

apply_dialog_theme() {
    local dialogrc="/tmp/ais-dialogrc"
    cat > "$dialogrc" << 'EOF'
use_colors = ON
screen_color = (RED,BLACK,OFF)
shadow_color = (BLACK,BLACK,OFF)
dialog_color = (RED,BLACK,OFF)
title_color = (RED,BLACK,ON)
border_color = (RED,BLACK,ON)
button_active_color = (BLACK,RED,ON)
button_inactive_color = (RED,BLACK,OFF)
button_key_active_color = (BLACK,RED,ON)
button_key_inactive_color = (RED,BLACK,ON)
button_label_active_color = (BLACK,RED,ON)
button_label_inactive_color = (RED,BLACK,OFF)
inputbox_color = (RED,BLACK,OFF)
inputbox_border_color = (RED,BLACK,ON)
searchbox_color = (RED,BLACK,OFF)
searchbox_title_color = (RED,BLACK,ON)
searchbox_border_color = (RED,BLACK,ON)
position_indicator_color = (RED,BLACK,ON)
menubox_color = (RED,BLACK,OFF)
menubox_border_color = (RED,BLACK,ON)
item_color = (RED,BLACK,OFF)
item_selected_color = (BLACK,RED,ON)
tag_color = (RED,BLACK,ON)
tag_selected_color = (BLACK,RED,ON)
check_color = (RED,BLACK,ON)
check_selected_color = (BLACK,RED,ON)
uarrow_color = (RED,BLACK,ON)
darrow_color = (RED,BLACK,ON)
itemhelp_color = (RED,BLACK,OFF)
form_active_text_color = (RED,BLACK,OFF)
form_text_color = (RED,BLACK,OFF)
form_item_readonly_color = (RED,BLACK,ON)
EOF
    export DIALOGRC="$dialogrc"
}

apply_default_theme() {
    # Default to a dark red-ish palette without prompting.
    wal -q --theme "sexy-tangoesque" 2>/dev/null || wal -q --theme "sexy-s3r0-modified" 2>/dev/null || true
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
