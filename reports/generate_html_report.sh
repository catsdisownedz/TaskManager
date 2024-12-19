#!/usr/bin/env bash
# generate_html_report.sh
# Generates an HTML report by substituting latest values into the template.

LOG_FILE="../data/logs/system_metrics.log"
TEMPLATE="./templates/report_template.html"

DATE=$(date +"%Y-%m-%d %H:%M:%S")
CPU_USAGE=$(grep CPU_USAGE $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
CPU_TEMP=$(grep CPU_TEMP $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
MEM_USAGE=$(grep MEM_USAGE $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
DISK_USAGE=$(grep DISK_USAGE $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
DISK_SMART=$(grep DISK_SMART $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
GPU_UTIL=$(grep GPU_UTIL $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
NET_RX_BYTES=$(grep NET_RX_BYTES $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
NET_TX_BYTES=$(grep NET_TX_BYTES $LOG_FILE | tail -1 | awk -F'|' '{print $3}')
LOAD_AVG=$(grep LOAD_AVG $LOG_FILE | tail -1 | awk -F'|' '{print $3}')

sed -e "s/{{DATE}}/$DATE/g" \
    -e "s/{{CPU_USAGE}}/$CPU_USAGE/g" \
    -e "s/{{CPU_TEMP}}/$CPU_TEMP/g" \
    -e "s/{{MEM_USAGE}}/$MEM_USAGE/g" \
    -e "s/{{DISK_USAGE}}/$DISK_USAGE/g" \
    -e "s/{{DISK_SMART}}/$DISK_SMART/g" \
    -e "s/{{GPU_UTIL}}/$GPU_UTIL/g" \
    -e "s/{{NET_RX_BYTES}}/$NET_RX_BYTES/g" \
    -e "s/{{NET_TX_BYTES}}/$NET_TX_BYTES/g" \
    -e "s/{{LOAD_AVG}}/$LOAD_AVG/g" \
    "$TEMPLATE"
