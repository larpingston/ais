#!/bin/bash

#straight coppied from kkrruumm's viss script because yes.....

option_timezone() {
    # Most of this timezone section is taken from the normal Void installer.
    local areas=(Africa America Antarctica Arctic Asia Atlantic Australia Europe Indian Pacific)

    if area=$(IFS='|'; monolog --no-cancel \
                    --title "Set Timezone" \
                    --menu "" 0 0 0 $(printf '%s||' "${areas[@]}")) 
    then
        read -a locations -d '\n' < <(find /usr/share/zoneinfo/$area -type f -printf '%P\n' | sort) || echo "Disregard exit code"
        local location=$(IFS='|'; monolog --no-cancel \
        --title "Set Timezone" \
        --menu "" 0 0 0 $(printf '%s||' "${locations[@]//_/ }"))
    fi

    local location=$(echo $location | tr ' ' '_')
    TIMEZONE="$area/$location"

        option_locale
}