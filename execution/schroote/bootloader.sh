#!/bin/bash

execute_bootloader() {

    if [ "$SWAP_STYLE" == "partition" ]
    then
        SWAP_RESUME="resume=$SWAP"
    fi

    if [ "$FILESYSTEM" == "btrfs" ]
    then
        ROOTFLAG="rootflags=subvol=/@"
    fi

    ROOT_UUID=$(blkid -s UUID -o value "$ROOT")
    
	KERNEL_PARAMETERS="root=$ROOT $ROOTFLAG $SWAP_RESUME initrd=\booster-$KERNEL.img initrd=\\$UCODE.img rw add_efi_memmap quiet $NVIDIA_MODESET"

    for i in $BOOTLOADER;
    do
	    execute_$i
	done

        execute_end
}

execute_refind() {

    install refind

    refind-install --usedefault "$ESP" --alldrivers
    mkrlconf

cat > /boot/refind_linux.conf << EOF 
"Boot with minimal options"   "root=$ROOT $ROOTFLAG $SWAP_RESUME initrd=\booster-$KERNEL.img initrd=\\$UCODE.img rw add_efi_memmap quiet $NVIDIA_MODESET"
EOF
}

execute_grub() {
    install grub os-prober

    if [ -d /sys/firmware/efi ]; then
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Artix
    else
        grub-install --target=i386-pc "$DISK"
    fi

    grub-mkconfig -o /boot/grub/grub.cfg
}

execute_efistub() {

        efibootmgr --create \
 --disk $DISK --part 1 \
 --label "Artix Linux EFISTUB" \
 --loader /vmlinuz-$KERNEL \
 --unicode "root=$ROOT $ROOTFLAG $SWAP_RESUME initrd=\booster-$KERNEL.img initrd=\\$UCODE.img rw add_efi_memmap quiet $NVIDIA_MODESET"   

}

execute_efistub-fallback() {

        efibootmgr --create \
 --disk $DISK --part 1 \
 --label "Artix Linux EFISTUB-fallback" \
 --loader /vmlinuz-$KERNEL \
 --unicode "initrd=\booster-$KERNEL-universal.img"   

}

execute_limine() {
    install limine
        
    mkdir -p /boot/EFI/BOOT
    cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT
    
        efibootmgr --create \
 --disk $DISK --part 1 \
 --label "Artix Linux LIMINE" \
 --loader '\EFI\BOOT\BOOTX64.efi' \
 --unicode    
    
        touch /boot/EFI/BOOT/limine.conf

    if [ "$UCODE" == "" ]
    then
        $UCODE_PATH="module_path: boot():/$UCODE.img"
    fi

cat > /boot/EFI/BOOT/limine.conf << EOF 
timeout: 5

/Arch Linux
    protocol: linux
    path: boot():/vmlinuz-$KERNEL
    cmdline: root=UUID=$ROOT_UUID rw
    module_path: boot():/booster-$KERNEL.img
    $UCODE_PATH

EOF

    touch /etc/pacman.d/hooks/99-limine.hook

    echo "[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = limine              

[Action]
Description = Deploying Limine after upgrade...
When = PostTransaction
Exec = /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT " > /etc/pacman.d/hooks/99-limine.hook

}
