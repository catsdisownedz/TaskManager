#!/usr/bin/env bash

LOG_FILE="../data/logs/system_metrics.log"
mkdir -p ../data/logs

log_metric() {
    local metric_type="$1"
    local value="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${timestamp}|${metric_type}|${value}" >> "${LOG_FILE}"
}
