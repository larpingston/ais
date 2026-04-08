#!/bin/bash

options() {

    if OPTIONS=$(monolog --title "CONFIRM" \
    --extra-button --extra-label "MAP" \
    --yesno "Are you sure you want to continue with those settings?\n\
Disk: $DISK\nDisk format method: $DISK_METHOD\n\
LVM: $LVM\nFilesystem: $FILESYSTEM\nSwap style: $SWAP_STYLE\
\nEncryption: $ENCRYPTION\nWipe disk: $WIPE_DISK\n\
Init: $INIT\nHostname: $HOSTNAME\
\nUsername: $USERNAME\nTimezone: $TIMEZONE\nLocale: $LOCALE\
\nBootloader: $BOOTLOADER\nAUR: $AUR\nKernel: $KERNEL\
\nNetwork: $NETWORK\nGraphics: $GRAPHICS\
\nDesktop: $DESKTOP" 0 0 
    )
    then
        execute_wipe
        exit 0
    else
        [ "$?" == "3" ] && map
        exit 0
    fi

}
