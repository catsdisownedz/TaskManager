#!/usr/bin/env bash
# main_menu.sh
# The main menu of the dashboard with options:
# - Live Stats
# - Reports
# - Search Historical Data
# - Exit

source ./utils.sh

while true; do
    CHOICE=$(zenity --list --title="Main Menu" \
        --text="$(heading_text 'System Monitoring Dashboard')\n$(body_text 'Choose an option:')" \
        --column="ID" --column="Action" \
        1 "View Live Stats" \
        2 "Reports" \
        3 "Search Historical Data" \
        4 "Exit" \
        --height=300 --width=400)

    case $CHOICE in
        1)
            ./live_stats.sh
            ;;
        2)
            ./reports_menu.sh
            ;;
        3)
            ./search_menu.sh
            ;;
        4)
            break
            ;;
        *)
            break
            ;;
    esac
done
