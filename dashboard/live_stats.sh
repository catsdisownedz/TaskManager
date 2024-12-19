#!/usr/bin/env bash
# live_stats.sh
# Continuously updates a Zenity dialog every second with current CPU/Memory usage to mimic "moving stats".
#
# Note: Zenity does not support updating a dialog in-place easily.
# We'll close and reopen it every second to simulate live updates.
# Pressing "Cancel" closes the loop.

source ./utils.sh

while true; do
    # Extract the latest metrics
    CPU=$(grep CPU_USAGE ../data/logs/system_metrics.log | tail -1 | awk -F'|' '{print $3}')
    MEM=$(grep MEM_USAGE ../data/logs/system_metrics.log | tail -1 | awk -F'|' '{print $3}')

    # Construct HTML output
    # We'll show CPU and Memory usage updated every second.
    TEXT="$(heading_text 'Live Metrics')\n$(body_text "CPU Usage: ${CPU}%")\n$(body_text "Memory Usage: ${MEM}%")\n\n$(info_text "Press Cancel to go back.")"

    # Show Zenity dialog
    zenity --text-info --html --title="Live Stats" --ok-label="Cancel" --width=400 --height=200 --timeout=1 --filename=<(echo -e "$TEXT") 2>/dev/null

    # If user pressed "Cancel" or closed window, break
    if [ $? -ne 0 ]; then
        break
    fi

    sleep 1
done
