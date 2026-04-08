#!/bin/bash

execute_region() {

     ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime

      hwclock --systohc

    echo "$LOCALE_CHOICE UTF-8" > /etc/locale.gen
 
    echo "$LOCALE" > /etc/locale.conf
    locale-gen

        execute_dbus
}