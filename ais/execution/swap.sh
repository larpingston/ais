#!/bin/bash 

execute_swap_lvm() {

    if [ "$SWAP_STYLE" == "partition" ] && [ "$LVM" == "yes" ]
    then
        lvcreate --name swap -L "$SWAP_SIZE" artix || die
        mkswap /dev/artix/swap || die
        swapon /dev/artix/swap
    fi
    
    if [ "$SWAP_STYLE" == "partition" ] && [ "$LVM" == "no" ]
    then
        mkswap -L SWAP "$SWAP" || die
        swapon $SWAP
    fi

        execute_lvm_space
}

execute_swap() {

    if [ "$SWAP_STYLE" == "file" ] && [ "$FILESYSTEM" == "btrfs" ]
    then
        btrfs filesystem mkswapfile --size "$SWAP_SIZE" --uuid clear /mnt/swap/swapfile
        swapon /mnt/swap/swapfile
    fi
    if [ "$SWAP_STYLE" == "file" ] && [ "$FILESYSTEM" != "btrfs" ]
    then
    mkswap -U clear --size "$SWAP_SIZE" --file /mnt/swapfile
    fi

    if [ "$SWAP_STYLE" == "zram" ] 
    then
        echo "zram" >> /mnt/etc/modules-load.d/zram.conf
        echo "zramctl /dev/zram0 --algorithm lz4 --size $SWAP_SIZE" >> /mnt/etc/rc.local
        echo "mkswap -U clear /dev/zram0" >> /mnt/etc/rc.local
        echo "swapon --discard --priority 100 /dev/zram0" >> /mnt/etc/rc.local
    fi
}
