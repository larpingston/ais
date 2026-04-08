#!/bin/bash

SOURCES=$(ls /mnt/schroote/ -I chroot.sh -I modules )

for i in $SOURCES
do
	source /mnt/schroote/"$i"
done

	sed -i 's/^CheckSpace/#CheckSpace/' /etc/pacman.conf

	touch $SSHELL_CONFIG

execute_root_password


