#!/bin/bash

#very dirty file, i will have to clean it

execute_end() {

	    echo "$USER_PASSWORD1" | sudo -u $USERNAME chsh -s $(which $SSHELL)

    if [ "$SUPER" == "doas" ]
    then
            echo -e 'permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel' > /etc/doas.conf
	        sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/g' /etc/makepkg.conf

    else
            sed -i "s|$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL|%wheel ALL=(ALL) ALL|" /etc/sudoers
    fi

    if [ "$LOGIN" != "none" ]
    then
        case "$LOGIN" in
            sddm) install sddm sddm-$INIT ;;

            greetd) install greetd greetd-$INIT greetd-tuigreet
                sed -i "s|vt = 1|vt = 7|" /etc/greetd/config.toml
                sed -i "s|agreety --cmd /bin/sh|tuigreet -r -t --cmd $DESKTOP|" /etc/greetd/config.toml 
                ;;
        esac
            service "$LOGIN"
    fi 

    if [ "$SWAP_STYLE" == "file" ]
    then
            swapon /swapfile
    fi

	    umount -R /mnt

        rm -rf /mnt/schroote

  }

