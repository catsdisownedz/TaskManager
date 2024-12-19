#!/usr/bin/env bash
# run_all.sh
# Runs all metric collection scripts and checks alerts.

./collect_cpu.sh
./collect_gpu.sh
./collect_disk.sh
./collect_memory.sh
./collect_network.sh
./collect_system_load.sh
./alert.sh
