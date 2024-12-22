#!/bin/bash

function get_cpu_performance() {
    top -bn1 | grep '%Cpu(s):' | awk '{print int(100 - $8)}'
}

# function get_cpu_performance(){  
#     top -bn1 | grep '%Cpu(s):' | cut -d':' -f2 | awk '{print int($1)}'
    
# }

function get_disk_usage() {
    df --output=used,size --total | tail -1 | awk '{print ($1/$2)*100}'
}



function get_memory_usage() {
    free | awk '/Mem:/ {print ($3/$2)*100}'
}



cpu_usage=$(get_cpu_performance 2>/dev/null || echo "0")
disk_usage=$(get_disk_usage 2>/dev/null || echo "Used 0 / 0")
# used_disk_size=$(echo "$disk_usage" | awk '/^Used/ {print $3}' || echo "0")
# total_disk_size=$(echo "$disk_usage" | awk '/^Used/ {print $5}' || echo "0")
memory_usage=$(get_memory_usage 2>/dev/null || echo "Used 0 / 0")
# used_memory=$(echo "$memory_usage" | awk '/^Used/ {print $3}' || echo "0")
# total_memory=$(echo "$memory_usage" | awk '/^Used/ {print $5}' || echo "0")

cat <<EOF
{
  "timestamp": "$(date +"%Y-%m-%d %H:%M:%S")",
  "cpu": {
    "usage": "$cpu_usage"
  },
  "Disk": {
    "used": "$disk_usage",
    "total": "100"
  },
  "RAM": {
    "used": "$memory_usage",
    "total": "100"
  }
}
EOF
