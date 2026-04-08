#!/bin/bash

#Copied from KRUM's viss

option_modules() {
    # Unset to prevent duplicates
    [ -n "$modules" ] &&
        unset MODULES_ARRAY

    read -a MODULES_LIST -d '\n' < <(ls modules/ | sort)

    for i in "${MODULES_LIST[@]}"
    do
        if [ -e "modules/$i" ] && check_module ; then
            MODULES_ARRAY+=("'$title' '$description' '$status'")
        fi
    done

    # Using dash here as a simple solution to it misbehaving when ran with bash
    modules=( $(dash -c "dialog --begin 5 5 \
      --title 'HELPER' \
      --infobox 'elogind-replace is very experimental, I do not recommend it\nI2c is nice for monitors to change backlight, only option that works for me\nI recommend alo TLP if you are on laptop\nfor pipewire see README' 0 0 \
      --and-widget \
      --stdout \
    --title 'Extra Options'\
    --extra-button --extra-label "MAP" \
    --checklist 'Enable or disable extra install options: ' 0 0 0 $(echo "${MODULES_ARRAY[@]}")") ) 
    [ "$?" == "3" ] && map

        options
}

check_module() {
    
    # Past this, I'm going to leave verifying correctness to the author of the module.
    # Check that relevant stuff is even in the file:
    if grep "title="*"" "modules/$i" && { grep "status=on" "modules/$i" || grep "status=off" "modules/$i" ; } && { grep "description="*"" "modules/$i" ; } && { grep "main()" "modules/$i" ; }; then

        # Test for early failures such as the module requiring a username
        . "modules/$i" ||
            return 1

        return 0
    else
        return 1
    fi
}
