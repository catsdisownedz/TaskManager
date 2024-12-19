#!/usr/bin/env bash
# reports_menu.sh
# A submenu for reports: view generated reports, search them by timestamp, etc.

source ./utils.sh

while true; do
    CHOICE=$(zenity --list --title="Reports Menu" \
        --text="$(heading_text 'Reports Menu')\n$(body_text 'Choose an option:')" \
        --column="ID" --column="Action" \
        1 "View Latest Markdown Report" \
        2 "View Latest HTML Report" \
        3 "Back" \
        --height=300 --width=400)

    case $CHOICE in
        1)
            # Display markdown report as text
            zenity --text-info --title="Markdown Report" --filename=../reports/latest_report.md --width=600 --height=400
            ;;
        2)
            # Convert HTML report to text for Zenity or open in browser if we had a browser
            # Zenity doesn't render HTML as a webpage, just text. We'll show it as text for simplicity.
            zenity --text-info --title="HTML Report" --filename=../reports/latest_report.html --width=600 --height=400
            ;;
        3)
            break
            ;;
        *)
            break
            ;;
    esac
done
