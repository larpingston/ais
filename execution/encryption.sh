#!/bin/bash

execute_encryption() { 
    if [ "$ENCRYPTION" == "yes" ] 
    then

        clear 
        echo "Wait For encryption to end"

                    echo "$ENCRYPTION_PASSWORD1
                $ENCRYPTION_PASSWORD2
                " | cryptsetup luksFormat "$ROOT" 
        
        echo "$ENCRYPTION_PASSWORD1" | cryptsetup luksOpen "$ROOT" artix 

    fi
CRYPT="/dev/mapper/artix"

        execute_lvm
}
