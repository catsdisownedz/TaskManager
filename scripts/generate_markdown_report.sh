#!/usr/bin/env bash
# generate_markdown_report.sh
# Generates a timestamped Markdown report using report_template.md

LOG_FILE="../data/logs/system_metrics.log"
TEMPLATE="../reports/templates/report_template.md"
OUTPUT_DIR="../reports/markdown"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${OUTPUT_DIR}/report_${TIMESTAMP}.md"

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

mkdir -p $OUTPUT_DIR

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
    "$TEMPLATE" > "$OUTPUT_FILE"
