#!/bin/bash

welcome() {

    monolog \
    --title "AIS Setup" \
    --msgbox "Welcome to AIS (Artix Installer Script).\n\nNavigation:\n- Arrow keys to move\n- Enter to confirm\n- Space to toggle options\n- TAB to switch buttons\n\nTip: use the MAP button any time to jump between steps.\n\nNothing is applied until the final confirmation screen." 0 0

        apply_default_theme
        option_disk
}

