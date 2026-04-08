#!/bin/bash

option_filesystem() {

    FILESYSTEM=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "For kinda stable and performative filesystem use: EXT4 or if it feels spicy XFS\nFor unique experimental features like compress on write or snapshots use btrfs" 0 0 \
      --and-widget \
    --title "FILESYSTEM" \
    --extra-button --extra-label "MAP" \
    --nocancel \
    --menu  "Select Filesystem:" 0 0 0 \
    "ext4" "" "btrfs" "" "xfs" ""
    )
        [ "$?" == "3" ] && map

    if [ "$FILESYSTEM" == "btrfs" ]
    then
        LVM="no"
        option_compress
    else
	LVM="no"
        #option_lvm
    	option_swap_style
    fi
}

option_compress() {

    COMPRESSION=$(monolog --title "COMPRESSION" \
    --nocancel \
    --menu "Choose compression for btrfs: " 0 0 0 \
    "zstd" "" "lzo" "" "zlib" "" "none" ""
    )
    if [ "$COMPRESSION" == "none" ]
    then
        BTRFS_OPTIONS="rw,noatime,nocompress,discard=async"
        COMPRESS=$COMPRESSION
    else
        BTRFS_OPTIONS="rw,noatime,compress=$COMPRESSION,discard=async"
    fi
        option_swap_style
}
