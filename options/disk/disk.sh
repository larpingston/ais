#!/bin/bash

avaible_disk=$(lsblk -o NAME,SIZE,FSTYPE,LABEL | grep -E "sd|nvme|vd")
choose_disk=$(lsblk -o NAME,SIZE -d | grep -E "sd|nvme|vd")

option_disk() {

    DISK=$(monolog --begin 5 5 \
    --title "Avaible disks" \
    --infobox "$avaible_disk" 0 0 \
    --and-widget \
    --title "DISK" \
    --extra-button --extra-label "MAP" \
    --nocancel \
    --menu "choose disk you would like to install to" 0 0 0 $choose_disk
    )
        [ "$?" == "3" ] && map

            DISK="/dev/$DISK"


        option_disk_method
}

option_disk_method() {

    DISK_METHOD=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "Automatic scheme:\n500M efi partition\nSWAP SIZE swap partition\nRest will be root partition" 0 0 \
      --and-widget \
    --title "FORMAT METHOD" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu "Choose how would you like to format $DISK" 0 0 0 \
    "automatic" "Everything will be formated using scheme" "manual" "You will do it yourself with cfdisk"
    )
        [ "$?" == "3" ] && map
       
		if [ "$DISK_METHOD" == "automatic" ]
		then	
        option_add_disk
		else
				option_filesystem
				DISK_TO_ADD=no
		fi
			}

option_add_disk() {
    if DISK_ADD=$(monolog --begin 5 5 \
      --title "HELPER" \
      --infobox "If you have other hard drives and would like to mount them automatically after startup there You can add it" 0 0 \
      --and-widget \
      --title "Anything to add?" \
    --defaultno \
    --yesno "would you like to mount additional disks?" 0 0 
    )
    then
        DISK_TO_ADD="yes"
        option_what_add_disk
	else
        DISK_TO_ADD="no"
	option_filesystem

    fi
}

option_what_add_disk() {

PARTITIONZ=$(lsblk -o NAME,SIZE | grep '─' | sed 's/.*─//')

    if WHAT_ADD_DISK=$(dialog --stdout --title "What to add" \
            --extra-button --extra-label "NEXT" \
            --menu "What partition would you like to mount?" 0 0 0 \
            $PARTITIONZ)
    then
        ADD_DISK+="/dev/$WHAT_ADD_DISK "
        option_where_add_disk
    else
        [ "$?" == "3" ] && option_filesystem
    fi
}

option_where_add_disk() {

    WHERE_ADD_DISK=$(dialog --stdout --title "Where to add?" \
    --nocancel \
    --inputbox "Where would you like to add? (write full path like /media/ssd)" 0 0 )

    WHERE_DISK+="$WHERE_ADD_DISK "
    ADD_DISK+="$WHERE_ADD_DISK "

        option_what_add_disk
}
