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
# gpu_info=$(get_gpu_info)
# network_stats=$(get_network_stats)
# system_load=$(get_system_load)


json_data=$(cat <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "cpu": {
    "usage": "$cpu_usage",
    "temperature": "$cpu_temp"
  },

  "Disk":{
    "used": "$used_disk_size",
    "total":"$total_disk_size"
  },

  "RAM":{
    "used": "$used_memory",
    "total":"$total_memory"
  }
 
}
EOF
)

# Output JSON to a file
OUTPUT_FILE="json_metrics.json"
echo "$json_data" > "$OUTPUT_FILE"

# Print confirmation
echo "DATA IS TRANSFERRED YAY"



# json_data=$(cat <<EOF
# {
#   "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
#   "cpu": {
#     "usage": "$cpu_usage",
#     "temperature": "$cpu_temp"
#   },
#   "disk": "$disk_usage",
#   "memory": "$memory_usage",
#   "gpu": "$gpu_info",
#   "network": "$network_stats",
#   "system_load": "$system_load"
# }
# EOF
# )


