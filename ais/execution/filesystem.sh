#!/bin/bash

execute_fs() {

    case $FILESYSTEM in
        btrfs) execute_btrfs ;;
        ext4) execute_ext4 ;;
        xfs) execute_xfs ;;
    esac

        execute_swap
        execute_fat
        

}

execute_fat() {

    if [ "$BOOTLOADER" != "none" ]
    then
        mkfs.fat -F 32 -n "ESP" "$ESP"
    fi
        mkdir -p /mnt/boot
        mount "$ESP" /mnt/boot

        execute_additional_disk
}

execute_btrfs() {

    if [ "$ENCRYPTION" == "yes" ]
    then
        mkfs.btrfs -f -L ARTIX $CRYPT
        mount -o $BTRFS_OPTIONS $CRYPT /mnt

                btrfs subvolume create /mnt/@
                btrfs subvolume create /mnt/@home
                btrfs subvolume create /mnt/@cache
                btrfs subvolume create /mnt/@log
                btrfs subvolume create /mnt/@opt
                btrfs subvolume create /mnt/@snapshots

                if [ "$SWAP_STYLE" == "file" ]
                then
                    btrfs subvolume create /mnt/@swap 
                fi

                umount /mnt
    else
        mkfs.btrfs -f -L ARTIX $ROOT
        mount -o $BTRFS_OPTIONS $ROOT /mnt

                btrfs subvolume create /mnt/@
                btrfs subvolume create /mnt/@home
                btrfs subvolume create /mnt/@cache
                btrfs subvolume create /mnt/@log
                btrfs subvolume create /mnt/@opt
                btrfs subvolume create /mnt/@snapshots
                
                if [ "$SWAP_STYLE" == "file" ] 
                then
                    btrfs subvolume create /mnt/@swap 
                fi

                umount /mnt
    fi

    if [ "$ENCRYPTION" == "yes" ]
    then
        mount -o $BTRFS_OPTIONS,subvol=@ $CRYPT /mnt

        mkdir -p /mnt/{var,home,.snapshots}

@home
                btrfs subvolume create /mnt/@cache
                btrfs subvolume create /mnt/@log
                btrfs subvolume create /mnt/@opt
                btrfs subvolume create /mnt/@snapshots

                if [ "$SWAP_STYLE" == "file" ]
                then
                    btrfs subvolume create /mnt/@swap 
                fi

                umount /mnt
    else
        mkfs.btrfs -f -L ARTIX $ROOT
        mount -o $BTRFS_OPTIONS $ROOT /mnt

                btrfs subvolume create /mnt/@
                btrfs subvolume create /mnt/@home
                btrfs subvolume create /mnt/@cache
                btrfs subvolume create /mnt/@log
                btrfs subvolume create /mnt/@opt
                btrfs subvolume create /mnt/@snapshots
                
                if [ "$SWAP_STYLE" == "file" ] 
                then
                    btrfs subvolume create /mnt/@swap 
                fi

                umount /mnt
    fi

    if [ "$ENCRYPTION" == "yes" ]
    then
        mount -o $BTRFS_OPTIONS,subvol=@ $CRYPT /mnt

        mkdir -p /mnt/{var,home,.snapshots}

        mount -o $BTRFS_OPTIONS,subvol=@home $CRYPT /mnt/home
        mount -o "$BTRFS_OPTIONS",nodatacow,subvol=@cache $CRYPT /mnt/var/cache
        mount -o "$BTRFS_OPTIONS",nodatacow,subvol=@log $CRYPT /mnt/var/log
        mount -o $BTRFS_OPTIONS,subvol=@opt $CRYPT /mnt/opt
        mount -o $BTRFS_OPTIONS,subvol=@snapshots $CRYPT /mnt/.snapshots

        if [ "$SWAP_STYLE" == "file" ]  
        then
            mkdir /mnt/swap ; mount -o rw,nodatacow,compress=none,subvol=@swap $CRYPT /mnt/swap 
        fi

    else
        mount -o $BTRFS_OPTIONS,subvol=@ $ROOT /mnt

        mkdir -p /mnt/{var,home,.snapshots}

        mount -o $BTRFS_OPTIONS,subvol=@home $ROOT /mnt/home
        mount -o "$BTRFS_OPTIONS",nodatacow,subvol=@cache $ROOT /mnt/var/cache
        mount -o "$BTRFS_OPTIONS",nodatacow,subvol=@log $ROOT /mnt/var/log
        mount -o $BTRFS_OPTIONS,subvol=@opt $ROOT /mnt/opt
        mount -o $BTRFS_OPTIONS,subvol=@snapshots $ROOT /mnt/.snapshots

        if [ "$SWAP_STYLE" == "file" ] 
        then
            mkdir /mnt/swap ; mount -o rw,nodatacow,compress=none,subvol=@swap $ROOT /mnt/swap 
        fi

    fi 

    for i in root tmp srv ;
    do
        btrfs subvolume create /mnt/"$i"
    done

    mkdir /mnt/usr
    btrfs subvolume create /mnt/usr/local

}

execute_ext4() {

    if [ "$LVM" == "yes" ]
    then
        mkfs.ext4 -F -L ARTIX $LVMROOT 
        mount -o noatime $LVMROOT /mnt

    elif [ "$LVM" == "no" ] && [ "$ENCRYPTION" == "yes" ]
    then
        mkfs.ext4 -F -L ARTIX $CRYPT
        mount -o noatime $CRYPT /mnt

    elif [ "$LVM" == "no" ] && [ "$ENCRYPTION" == "no" ]
    then
        mkfs.ext4 -F -L ARTIX $ROOT
        mount -o noatime $ROOT /mnt
    fi
}

execute_xfs() {

    if [ "$LVM" == "yes" ]
    then
        mkfs.xfs -f -L ARTIX $LVMROOT
        mount $LVMROOT /mnt

    elif [ "$LVM" == "no" ] && [ "$ENCRYPTION" == "yes" ]
    then
        mkfs.xfs -f -L ARTIX $CRYPT
        mount $CRYPT /mnt

    elif [ "$LVM" == "no" ] && [ "$ENCRYPTION" == "no" ]
    then
        mkfs.xfs -f -L ARTIX $ROOT
        mount $ROOT /mnt
    fi
}

execute_additional_disk() {

    if [ "$DISK_TO_ADD" == "yes" ]
    then
	for i in $WHERE_DISK
	do
		mkdir -p /mnt/$i
	done

        printf "%s %s\n" $ADD_DISK |
	while read -r ab cd
	do
	mount $ab /mnt$cd
	done

	
    fi

    execute_base
}
