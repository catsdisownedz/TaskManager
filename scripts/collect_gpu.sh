#!/usr/bin/env bash
# collect_gpu.sh
# Collects GPU utilization if nvidia-smi is available.

source ./logging.sh

if command -v nvidia-smi >/dev/null 2>&1; then
    GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    log_metric "GPU_UTIL" "$GPU_UTIL"
    curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "gpu_util value=$GPU_UTIL" > /dev/null
fi
