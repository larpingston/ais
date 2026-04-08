#!/bin/bash#!/bin/bash

# agaaainnn coppied from kkrruumm's viss script but with minor changes

option_locale() {

    # This line is also taken from the normal Void installer.
    locale_list=$(grep -E '\.UTF-8' /etc/locale.gen | awk '{print $1}' | sed -e 's/^#//')

            for i in $locale_list
            do
                # We don't need to specify an item here, only a tag and print it to stdout
                tmp+=("$i" $(printf '\u200b')) # Use a zero width unicode character for the item
            done

    LOCALE_CHOICE=$(monolog --no-cancel \
     --title "Locale Selection" \
     --menu "Please choose your system locale." 0 0 0 ${tmp[@]})
    LOCALE="LANG=$LOCALE_CHOICE"

        option_bootloader
}