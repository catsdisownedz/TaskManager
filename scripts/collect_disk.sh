#!/usr/bin/env bash
# collect_disk.sh
# Collects disk usage and SMART status.

source ./logging.sh

# DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
# log_metric "DISK_USAGE" "$DISK_USAGE"
# curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "disk_usage value=$DISK_USAGE" > /dev/null

# if command -v smartctl >/dev/null 2>&1; then
#     SMART_STATUS=$(smartctl -H /dev/sda | grep "overall-health" | awk '{print $NF}')
#     log_metric "DISK_SMART" "$SMART_STATUS"
#     curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "disk_smart_status value=\"${SMART_STATUS}\"" > /dev/null
# fi
