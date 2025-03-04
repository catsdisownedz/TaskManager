#!/bin/bash

# Source the systematics file to use its functions
source ./systemMetrics.sh




# Get metrics from systemMetrics

cpu_usage=$(get_cpu_performance)

cpu_temp=$(get_cpu_temp)

disk_usage=$(get_disk_usage)
used_disk_size=$(echo "$disk_usage" | awk '/^Used/ {print $3}')
total_disk_size=$(echo "$disk_usage" | awk '/^Used/ {print $5}')

memory_usage=$(get_memory_usage)
used_memory=$(echo "$memory_usage" | awk '/^Used/ {print $3}')
total_memory=$(echo "$memory_usage" | awk '/^Used/ {print $5}')


generate_report_file() {
  # Construct JSON data
  json_data=$(cat <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "cpu": {
    "usage": "$cpu_usage",
    "temperature": "$cpu_temp"
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
)

  # Output JSON to a file
  OUTPUT_FILE="data.json"
  echo "$json_data" > "$OUTPUT_FILE"

  # Print confirmation
  echo "DATA IS TRANSFERRED YAY"
}
