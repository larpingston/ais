#!/bin/bash

option_encryption() {

    if ENCRYPTION=$(monolog --begin 5 5 \
    --title "HELPER" \
    --infobox "Everytime you are booting you will have to write password to decrypt disk so you can read and write things to it.\nMight be good on laptops" 0 0 \
    --and-widget \
    --title "ENCRYPTION" \
    --no-cancel \
    --yesno "Would you like to encrypt disk?" 0 0 \
    )
    then
        ENCRYPTION="yes"
            option_encryption_password
    else
        [ "$?" == "3" ] && map
        ENCRYPTION="no"
    fi
        option_init
}

option_encryption_password() {

    ENCRYPTION_PASSWORD1=$(monolog --title "ENCRYPTION PASSWORD" \
    --no-cancel \
    --insecure \
    --passwordbox "Write password which you will use to decrypt disk" 0 0 \
    )

    ENCRYPTION_PASSWORD2=$(monolog --title "ENCRYPTION PASSWORD" \
    --no-cancel \
    --insecure \
    --passwordbox "Verify password which you will use to decrypt disk" 0 0 \
    )

    if [[ "$ENCRYPTION_PASSWORD1" != "$ENCRYPTION_PASSWORD2" ]]
    then
        option_wrong_password
        option_encryption_password
    else
        option_wipe_disk
    fi
}

option_wipe_disk() {

    if WIPE_DISK=$(monolog --begin 5 5 \
    --title "HELPER" \
    --infobox "This option will erase everything on your disk. Even recovery tools won't be able to recover deleted things.\nDon't do it if \
you don't know what is that" 0 0 \
    --and-widget \
    --title "WIPING" \
    --defaultno \
    --yesno "Do you want to Wipe disk?" 0 0
    )
    then
        option_wipe_disk_confirm
    else
        WIPE_DISK="no"
    fi
}

option_wipe_disk_confirm() {

    if WIPE_DISK=$(monolog --title "WIPING" \
    --yesno "Are you really really realyyy sure?? IT WILL ERASE EVERYTHING!" 0 0
    )
    then
        WIPE_DISK="yes"
    else
        WIPE_DISK="no"
    fi

}