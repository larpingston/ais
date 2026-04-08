#!/bin/bash

SOURCES=$(find . -type f -not -path "./execution/schroote/*" -not -path "./ais.sh" -not -path "./.git/*" -printf '%P\n')

for i in $SOURCES 
do
	source "$i"
done

check_root
check_connection
check_uefi

sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf

if [[ $1 == -b ]]
then
  pacman -Sy -q --noconfirm --needed dialog dash &>/dev/null | echo "Instaling dependencies..."
else

pacman -Sy -q --noconfirm --needed xorg-xdpyinfo dialog python-pywal terminus-font dash &>/dev/null | echo "Instaling dependencies..."

resolution=$(xdpyinfo | awk '/dimensions/{print $2}')

case $resolution in 
	1920x1080) setfont ter-d24b.psf.gz ;;
	1680x1050) setfont ter-d20b.psf.gz ;;
	1368x768) setfont ter-d16b.psf.gz ;;
	1280x720) setfont ter-d16b.psf.gz ;;
esac


fi


welcome
