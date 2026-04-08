#!/bin/bash

option_dns() {

    DNS=$(monolog --begin 5 5 \
      --title "HELPER" \
			--infobox "DNS (Dynamic Name System). By default you send site queries to your ISP, but you can change it.\nCustom DNS can block ads and some tracking on sites." 0 0 \
      --and-widget \
    --title "DNS" \
    --no-cancel \
    --extra-button --extra-label "MAP" \
    --menu  "Select your DNS Resolver:" 0 0 0 \
		"none" "" "194.242.2.3" "mullvad" "9.9.9.9" "quad9" "94.140.14.14" "adguard" "custom" "You will type adress"
    )

		[ "$?" == "3" ] && map
		
		if [ "$DNS" == "custom" ]
		then
			option_dns_custom
		else
        option_graphics
		fi
}

option_dns_custom() {

		DNS=$(monolog --title "Custom DNS" \
		--no-cancel \
		--extra-button --extra-label "MAP" \
		--inputbox "type in number xxx.xxx.xxx.xxx" 0 0 \
	)

			[ "$?" == "3" ] && map
				option_graphics
}

