#!/bin/bash

option_root_password() {

    ROOT_PASSWORD1=$(monolog --title "ROOT PASSWORD" \
    --no-cancel \
    --insecure \
    --passwordbox "Write root password" 0 0 \
    )

    ROOT_PASSWORD2=$(monolog --title "ROOT PASSWORD" \
    --no-cancel \
    --insecure \
    --passwordbox "Verify root password" 0 0 \
    )

    if [[ "$ROOT_PASSWORD1" != "$ROOT_PASSWORD2" ]]
    then
        option_wrong_password
        option_root_password
    fi

        option_user_create
}