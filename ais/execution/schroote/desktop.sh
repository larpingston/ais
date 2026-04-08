#!/bin/bash

execute_aur() {

echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

        sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 20/' /etc/pacman.conf

    case $AUR in
	    yay) install go ;;
        paru) install rust ;;	
	    trizen) install trizen ;;
	    yaourtix) install yaourtix ;;
    esac

    if [ "$AUR" == "yay" ] || [ "$AUR" == "paru" ]
    then

DIRR=${PWD}
chown $USERNAME /opt
cd /opt
sudo -u $USERNAME git clone https://aur.archlinux.org/$AUR.git
chown $USERNAME $AUR/
cd $AUR
sudo -u $USERNAME makepkg -si --noconfirm
sudo pacman -U --noconfirm *.pkg.tar.zst
cd $DIRR
rm -rf /home/$USERNAME/$AUR

    fi

        execute_desktop
}

execute_desktop() {

    case $DESKTOP in
    hyprland) install hyprland ;;
    sway) install sway ;;
    river) install river-classic ;; 
    niri) install niri ;;
    kde) install plasma-desktop ;;
    xfce) install xfce4 ;;
    bspwm) install bspwm sxhkd & XORG="yes" ;;
    i3) install i3-wm & XORG="yes" ;;
esac

    if [ "$LOGIN" == "greetd" ] && [ "$XORG" == "yes" ]
    then
      install xorg-xinit
      touch /home/$USERNAME/.xinitrc
      echo "#!/bin/bash
exec $DESKTOP" > /home/$USERNAME/.xinitrc
  DESKTOP="startx"
  fi
        execute_graphics
}

