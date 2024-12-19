#!/usr/bin/env bash
# search_menu.sh
# Allows user to enter start/end timestamps and queries historical data via Python.

source ./utils.sh

while true; do
    # Ask user for start time
    START=$(zenity --entry --title="Historical Data Search" --text="$(body_text 'Enter start timestamp (e.g. 2024-12-17T00:00:00Z or now()-1h)'):" --width=400)
    [ $? -ne 0 ] && break

    # Ask user for end time
    END=$(zenity --entry --title="Historical Data Search" --text="$(body_text 'Enter end timestamp (e.g. 2024-12-17T01:00:00Z or now())'):" --width=400)
    [ $? -ne 0 ] && break

    # Run Python query
    OUTPUT=$(python3 ../python/process_data.py "$START" "$END")

    # Show results
    zenity --text-info --title="Historical Data Results" --width=600 --height=400 --filename=<(echo "$OUTPUT")

    # After showing results, ask if user wants to go back or search again
    ASK=$(zenity --list --title="Search Again?" \
        --text="$(body_text 'Search again or go back?')" \
        --column="ID" --column="Action" \
        1 "Search Again" \
        2 "Back" \
        --height=200 --width=300)

    case $ASK in
        1) continue ;;
        2) break ;;
        *) break ;;
    esac
done
