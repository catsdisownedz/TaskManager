#!/usr/bin/env bash
# collect_memory.sh
# Collects Memory usage percentage.

source ./logging.sh

MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
log_metric "MEM_USAGE" "$MEM_USAGE"
curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "mem_usage value=$MEM_USAGE" > /dev/null
