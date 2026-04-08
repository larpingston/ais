#!/bin/bash

execute_dbus() {

    install dbus dbus-$INIT
    service dbus

        execute_network
}

execute_network() {

    install $NETWORK $NETWORK-$INIT 

    case $NETWORK in
        networkmanager) service NetworkManager ;;
        connman) service connmand ;;
        
	iwd)install dhcpcd dhcpcd-$INIT
		service iwd
		service dhcpcd ;;
	
	dhcpcd) service dhcpcd ;; 
	esac

        execute_dns
}

execute_dns() {

		if [ "$DNS" != "none" ]
		then

		install openresolv

		resolvconf -u
		echo "name_servers=$DNS" >> /etc/resolvconf.conf
	 	resolvconf -u

		fi

		execute_aur
	
	}
