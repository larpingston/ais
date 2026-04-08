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
