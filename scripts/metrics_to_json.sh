#!/bin/bash

function get_cpu_performance() {
    top -bn1 | grep '%Cpu(s):' | awk '{print int(100 - $8)}'
}

function get_disk_usage() {
    df --output=used,size --total | tail -1 | awk '{printf("%.2f", ($1/$2)*100)}'
}

function get_memory_usage() {
    free | awk '/Mem:/ {printf("%.2f", ($3/$2)*100)}'
}

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
filename=$(date +"%Y-%m-%dT%H-%M-%S").log

cpu_usage=$(get_cpu_performance 2>/dev/null || echo "0")
disk_usage=$(get_disk_usage 2>/dev/null || echo "0")
memory_usage=$(get_memory_usage 2>/dev/null || echo "0")

cat <<EOF
{
  "timestamp": "$timestamp",
  "filename": "$filename",
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
