#!/usr/bin/env bash
# run_all.sh
# run_all.sh
./scripts/collect_cpu.sh
./scripts/collect_gpu.sh
./scripts/collect_disk.sh
./scripts/collect_memory.sh
./scripts/collect_network.sh
./scripts/collect_system_load.sh
./scripts/alert.sh
