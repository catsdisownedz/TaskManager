#!/usr/bin/env bash
# alert.sh
# Checks if CPU or Disk usage exceed thresholds and prints alerts.

source ./logging.sh

CPU_THRESHOLD=90
DISK_THRESHOLD=90

CPU_USAGE=$(grep CPU_USAGE ../data/logs/system_metrics.log | tail -1 | awk -F'|' '{print $3}')
DISK_USAGE=$(grep DISK_USAGE ../data/logs/system_metrics.log | tail -1 | awk -F'|' '{print $3}')

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "ALERT: CPU usage exceeded ${CPU_USAGE}%!"
fi

if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
    echo "ALERT: Disk usage exceeded ${DISK_USAGE}%!"
fi
