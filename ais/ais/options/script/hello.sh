#!/bin/bash

welcome() {

    monolog --begin 5 5 \
    --title "Author" \
    --infobox "This script was brought to you by:\nUSER721/5150/187/1312" 0 0 \
    --and-widget \
    --title "WELCOME" \
    --msgbox "This is Artix linux installer script. I was inspired by krum's void install script\n\nTo navigate use arrow keys, enter, space, tab.\n\n\
Also you can press first letter of options for example: d for dinit.\n\nUse MAP button to navigate through functions, in case you would like to go back.\
\n\nOptions will not be executed untill the end of options when you will press confirm!\nI tried to put first option recommended\n\n READ EVERYTHING CAREFOULY!" 0 0

        option_theme
}

