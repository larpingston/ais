#!/bin/bash

remove() {

    pacman -Rnsdd --noconfirm "$@"

}

install() {

    pacman -Sy --noconfirm --needed "$@"

}

install_aur() {

    $AUR -Sy --noconfirm --needed "$@"

}

service() {

    case $INIT in
        dinit)  ln -sf /etc/dinit.d/"$@" /etc/dinit.d/boot.d/ ;;
        runit) ln -s /etc/runit/sv/"$@" /etc/runit/runsvdir/default ;;
        openrc) rc-update add "$@" ;;
        s6)  touch /etc/s6/adminsv/default/contents.d/"$@"
        s6-db-reload ;;
    esac
}

chroot() {

    artix-chroot /mnt /bin/bash -c "$@"

}

monolog() {

    dialog --stdout --erase-on-exit "$@"

}

map() {

    if OPTION_MAP=$(monolog --title "MAP" \
    --no-cancel \
    --menu "Where are you goin?" 0 0 0 \
    "Welcome" "" "Theme" "" "Disk" "" \
    "Additional Disk" "" "Filesystem" "" "Swap" "" \
    "Encryption" "" "Init" "" "Hostname" "" \
    "Root" "" "User" "" "Timezone" "" \
    "Bootloader" "" "Locale" ""\
    "AUR" "" "Kernel" "" "Shell" "" \
    "Network" "" "DNS" "" "Graphics" "" "Desktop" "" \
    "Modules" ""
    )
    then

        case $OPTION_MAP in
            Welcome) welcome ;;
            Theme) option_theme ;;
            Disk) option_disk ;;
            "Additional Disk") option_add_disk ;;
            Filesystem) option_filesystem ;;
            Swap) option_swap_style ;;
            Encryption) option_encryption ;;
            Init) option_init ;;
            Hostname) option_hostname ;;
            Root) option_root_password ;;
            User) option_user_create ;;
            Timezone) option_timezone ;;
            Locale) option_locale ;;
            Bootloader) option_bootloader ;;
            AUR) option_aur ;;
            Kernel) option_kernel ;;
            Shell) option_shell ;;
            Network) option_network ;;
						DNS) option_dns ;;
						Graphics) option_graphics ;;
            Desktop) option_desktop ;;
            Modules) option_modules ;;
        esac

    fi
}

option_wrong_password() {

    monolog --title "WRONG" \
    --msgbox "Passwords are not the same. Repeat action!!" 0 0

}

AUR="$AUR"
AUR="$AUR"
