#!/bin/bash

execute_graphics() {

    for i in $GRAPHICS
    do
        case $i in
            amd) install mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver ;;
            intel) install mesa xf86-video-intel vulkan-intel ;;
            nouveau) install mesa xf86-video-nouveau vulkan-nouveau  ;;

            nvidia-open) 

                if [ "$KERNEL" == "linux" ]
                    then
                        install nvidia-open nvidia-utils
                    else
                        install nvidia-open-dkms nvidia-utils
                fi  ;;

            nvidia-580) install nvidia-580xx-dkms nvidia-580xx-utils ;;
            nvidia-470) install nvidia-470xx-dkms nvidia-470xx-utils ;;
            nvidia-390) install nvidia-390xx-dkms nvidia-390xx-utils ;;
        esac
    done

    if [[ "$GRAPHICS" =~ "nvidia" ]]
    then

        echo "modules_force_load: nvidia,nvidia_modeset,nvidia_uvm,nvidia_drm" >> /etc/booster.yaml
        /usr/lib/booster/regenerate_images
        NVIDIA_MODESET="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"

echo '#!/bin/sh

case "$1" in
    pre)
        /usr/bin/nvidia-sleep.sh "suspend"
        ;;
    post)
        /usr/bin/nvidia-sleep.sh "resume"
        ;;
esac' > /lib64/elogind/system-sleep/nvidia
    
    fi

        execute_modules
}
