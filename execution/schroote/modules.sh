#!/bin/bash

execute_modules() {

        for i in ${mods[@]}
        do
            . "/mnt/schroote/modules/$i"
            main
        done

        execute_bootloader
}

