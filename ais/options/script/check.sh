#!/bin/bash

check_connection() {

        clear 
            ping gnu.org -c 2 -q -w 2 &>/dev/null 


    if [ $? = 0 ]; then

       clear

            echo -e "${GREEN}You are connected to the internet ${RESET}" 

        clear

    else

        clear

            echo -e "${RED}You are NOT connected to the internet ${RESET}\n" 

            echo -e "If you are using wifi do: \n
                    connmanctl \n
                    technologies \n
                    enable wifi \n
                    agent on \n
                    services \n
                    connect service (just do tab as service to your network) \n
                    type password \n
                    exit\n "
            exit 1
    fi
}



check_uefi() {


local uefi=""
local virt_type="none"

if [ -r /sys/firmware/efi/fw_platform_size ]; then
    uefi="$(cat /sys/firmware/efi/fw_platform_size 2>/dev/null)"
fi

if command -v systemd-detect-virt >/dev/null 2>&1; then
    virt_type="$(systemd-detect-virt 2>/dev/null)"
fi

    if [[ $uefi = "64" || $uefi = "32" ]]; then

        clear

            echo -e "${GREEN}You are using UEFI ${RESET}" 

        clear

    elif [[ -d /sys/class/dmi/id ]] && [[ $virt_type != "none" && -n $virt_type ]]; then

        clear

        echo -e "${YELLOW}No UEFI firmware detected, but virtualization was found (${virt_type}).${RESET}"
        echo -e "${YELLOW}Continuing in VM compatibility mode.${RESET}"
        sleep 1

    else

        clear

        echo -e "${RED}You are NOT using UEFI ${RESET}"
        echo -e "${RED}Use an UEFI booted environment or run this inside a VM.${RESET}"

        exit 1

    fi
}



check_root() {


    if [ $EUID != 0 ]; then

        clear

        echo -e "${RED}You have to run script as root user, do sudo ./ ${RESET}"
        
        exit 1
    
    else 

        clear

            echo -e "${GREEN}You are running script as root ${RESET}" 

        clear

    fi
}
