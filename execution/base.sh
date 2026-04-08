#!/bin/bash

execute_base() {

    basestrap /mnt base base-devel booster nvim git man elogind-$INIT $COMPRESS $KERNEL $KERNEL-headers linux-firmware \
    efibootmgr $SSHELL pacman-contrib polkit --ignore mkinitcpio

    if [ "$INIT" == "s6" ]
    then
        basestrap /mnt s6-base
    else
        basestrap /mnt $INIT
    fi


    if [ "$ENCRYPTION" == "yes" ]
    then
        basestrap /mnt cryptsetup cryptsetup-$INIT device-mapper-$INIT
    fi
    if [ "$LVM" == "yes" ]
    then
        basestrap /mnt lvm
    fi
    if [ "$FILESYSTEM" == "btrfs" ]
    then
        basestrap /mnt btrfs-progs
    fi

    fstabgen -U /mnt >> /mnt/etc/fstab

    if [ "$SWAP_STYLE" == "file" ]
    then
      echo "/swapfile none swap defaults 0 0" >> /mnt/etc/fstab
    fi

FIRST_TIME="yes"

        execute_chroot
        execute_end
}

execute_chroot() {

    export DISK="$DISK"
    export ENCRYPTION="$ENCRYPTION"
    export LVM="$LVM"
    export LVMROOT="$LVMROOT"
    export FILESYSTEM="$FILESYSTEM"
    export ROOT="$ROOT"
    export CRYPT="$CRYPT"
    export ESP="$ESP"
    export SWAP="$SWAP"
    export SWAP_SIZE="$SWAP_SIZE"
    export SWAP_STYLE="$SWAP_STYLE"
    export INIT="$INIT"
    export BOOTLOADER="$BOOTLOADER"
    export KERNEL="$KERNEL"
    export HOSTNAME="$HOSTNAME"
    export ENCRYPTION_PASSWORD1="$ENCRYPTION_PASSWORD1"
    export ENCRYPTION_PASSWORD2="$ENCRYPTION_PASSWORD2"
    export ROOT_PASSWORD1="$ROOT_PASSWORD1"
    export ROOT_PASSWORD2="$ROOT_PASSWORD2"
    export USER_PASSWORD1="$USER_PASSWORD1"
    export USER_PASSWORD2="$USER_PASSWORD2"
    export USERNAME="$USERNAME"
    export USER_HOME_CREATE="$USER_HOME_CREATE"
    export TIMEZONE="$TIMEZONE"
    export LOCALE_CHOICE="$LOCALE_CHOICE"
    export LOCALE="$LOCALE"
    export AUR="$AUR"
    export NETWORK="$NETWORK"
    export DNS="$DNS"
    export DESKTOP="$DESKTOP"
    export LOGIN="$LOGIN"
    export SSHELL="$SSHELL"
    export SSHELL_CONFIG="$SSHELL_CONFIG"
    export GRAPHICS=$GRAPHICS
    export mods=${modules[*]}

    if [ "$FIRST_TIME" == "yes" ]
    then
    cp -r execution/schroote/ /mnt/mnt/
    cp -r modules/ /mnt/mnt/schroote/
    cp -r options/script/variables.sh /mnt/mnt/schroote/

	chmod +x /mnt/mnt/schroote/chroot.sh
    artix-chroot /mnt bash -c /mnt/schroote/chroot.sh
    else
        artix-chroot /mnt
    fi
}

execute_end() {

    if CHROOT_MONOLOG=$(monolog --title "CHROOT" \
    --defaultno \
    --yesno "Would you like to chroot again into new system?" 0 0 )
    then
        FIRST_TIME="no"
        execute_chroot
    fi

    if END_MONOLOG=$(monolog --title "HAPPY END!" \
    --nocancel \
    --yesno "Would you like to reboot your system?" 0 0 )
    then
        reboot
    else
        exit
    fi

}
