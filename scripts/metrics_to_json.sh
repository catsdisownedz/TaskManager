#!/bin/bash

# Determine the directory of the current script
SCRIPT_DIR=$(dirname "$0")

# Source the system metrics functions using an absolute path
source "$SCRIPT_DIR/systemMetrics.sh"

# Collect metrics
cpu_usage=$(get_cpu_performance)
cpu_temp=$(get_cpu_temp)
disk_usage=$(get_disk_usage)
used_disk_size=$(echo "$disk_usage" | awk '/^Used/ {print $3}')
total_disk_size=$(echo "$disk_usage" | awk '/^Used/ {print $5}')
memory_usage=$(get_memory_usage)
used_memory=$(echo "$memory_usage" | awk '/^Used/ {print $3}')
total_memory=$(echo "$memory_usage" | awk '/^Used/ {print $5}')

# Output metrics in JSON format
cat <<EOF
{
  "timestamp": "$(date +"%Y-%m-%d %H:%M:%S")",
  "cpu": {
    "usage": "$cpu_usage"
  },
  "Disk": {
    "used": "$used_disk_size",
    "total": "$total_disk_size"
  },
  "RAM": {
    "used": "$used_memory",
    "total": "$total_memory"
  }
}
EOF
