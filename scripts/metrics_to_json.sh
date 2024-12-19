#!/bin/bash

# Source the systematics file to use its functions
source ./systematics

# Output file
OUTPUT_FILE="metrics.json"

# Get metrics
cpu_usage=$(get_cpu_performance)
cpu_temp=$(get_cpu_temp)
disk_usage=$(get_disk_usage)
memory_usage=$(get_memory_usage)
gpu_info=$(get_gpu_info)
network_stats=$(get_network_stats)
system_load=$(get_system_load)

# Build JSON object
json_data=$(cat <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "cpu": {
    "usage": "$cpu_usage",
    "temperature": "$cpu_temp"
  },
  "disk": "$disk_usage",
  "memory": "$memory_usage",
  "gpu": "$gpu_info",
  "network": "$network_stats",
  "system_load": "$system_load"
}
EOF
)

# Write to JSON file
echo "$json_data" > "$OUTPUT_FILE"

# Print success message
echo "Metrics saved to $OUTPUT_FILE"
