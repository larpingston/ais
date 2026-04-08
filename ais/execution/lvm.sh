#!/bin/bash

execute_lvm() {

    if [ "$LVM" == "yes" ] && [ "$ENCRYPTION" == "yes" ]
    then
        vgcreate artix /dev/mapper/artix
    elif [ "$LVM" == "yes" ] && [ "$ENCRYPTION" == "no" ]
    then
        pvcreate "$ROOT"
        vgcreate artix "$ROOT"
    fi

        execute_swap_lvm
}

execute_lvm_space() {

    if [ "$LVM" == "yes" ]
    then
        lvcreate --name root -l 100%FREE artix
    fi
LVMROOT="/dev/artix/root"
        execute_fs
}