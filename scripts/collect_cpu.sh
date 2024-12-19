#!/usr/bin/env bash
# collect_cpu.sh
# Collects CPU usage and temperature, logs them, and sends to InfluxDB.

source ./logging.sh

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100-$8}')
log_metric "CPU_USAGE" "$CPU_USAGE"

if command -v sensors >/dev/null 2>&1; then
    CPU_TEMP=$(sensors | grep -E 'CPU|Core 0' | head -1 | awk '{print $2}' | sed 's/+//;s/°C//')
    log_metric "CPU_TEMP" "$CPU_TEMP"
    curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "cpu_temp value=$CPU_TEMP" > /dev/null
fi

curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "cpu_usage value=$CPU_USAGE" > /dev/null
