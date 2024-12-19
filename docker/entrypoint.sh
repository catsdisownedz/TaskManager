#!/usr/bin/env bash
# entrypoint.sh
# This script runs when the container starts.
# It:
# 1. Prints ASCII banner.
# 2. Sets up InfluxDB database.
# 3. Runs initial metric collection.
# 4. Generates initial reports.
# 5. Launches the GUI dashboard.

cd /app

# Show ASCII banner
./scripts/ascii_banner.sh

# Setup InfluxDB
./scripts/setup_influxdb.sh

# Run initial metrics collection
./scripts/run_all.sh

# Generate initial reports
./scripts/generate_reports.sh

# Launch GUI dashboard automatically
./dashboard/dashboard.sh

# Keep container alive
tail -f /dev/null
