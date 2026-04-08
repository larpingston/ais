#!/bin/bash

execute_root_password() {

    echo -e "$ROOT_PASSWORD1\n$ROOT_PASSWORD2" | passwd

        execute_user_create
}

execute_user_create() {

    useradd $USER_HOME_CREATE $USERNAME
     usermod -a -G video,audio,input,storage,wheel,scanner,disk,power $USERNAME

        execute_user_password
}

execute_user_password() {

    echo -e "$USER_PASSWORD1\n$USER_PASSWORD2" | passwd $USERNAME

        execute_hostname
}

execute_hostname() {

echo "$HOSTNAME" > /etc/hostname

 echo -e "
127.0.0.1        localhost
::1              localhost
127.0.1.1        $HOSTNAME.localdomain  $HOSTNAME"      
    > /etc/hosts

    if [ "$INIT" == "openrc" ]
    then
        echo "hostname='$HOSTNAME'" > /etc/conf.d/hostname
    fi

        execute_region
}
