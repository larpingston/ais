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

    local selected_bootloaders
    selected_bootloaders="$(echo "$BOOTLOADER" | tr -d '"')"

    for i in $selected_bootloaders;
    do
        if [ "$i" = "efistub_fallback" ]; then
            execute_efistub_fallback
            continue
        fi

        if declare -F "execute_$i" >/dev/null 2>&1; then
            "execute_$i"
        fi
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
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Artix --removable --no-nvram
    else
        grub-install --target=i386-pc --modules="part_gpt biosdisk" "$DISK"
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

execute_efistub_fallback() {

        efibootmgr --create \
 --disk $DISK --part 1 \
 --label "Artix Linux EFISTUB-fallback" \
 --loader /vmlinuz-$KERNEL \
 --unicode "initrd=\booster-$KERNEL-universal.img"   

}

execute_limine() {
    if [ ! -d /sys/firmware/efi ]; then
        # Limine entry here is UEFI-only in this script; fallback to GRUB on BIOS VMs.
        execute_grub
        return
    fi

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
