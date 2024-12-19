#!/usr/bin/env bash
# collect_system_load.sh
# Collects system load average (1-minute).

source ./logging.sh

# LOAD_AVG=$(uptime | awk -F'load average:' '{ print $2 }' | awk '{print $1}')
# log_metric "LOAD_AVG" "$LOAD_AVG"
# curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "load_avg value=$LOAD_AVG" > /dev/null
