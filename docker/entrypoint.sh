#!/usr/bin/env bash

# Load environment variables from .env file if it exists
if [ -f "$(dirname "$0")/.env" ]; then
  export $(grep -v '^#' "$(dirname "$0")/.env" | xargs)
fi

# Convert line endings to Unix style
find /app -type f -name "*.sh" -exec dos2unix {} \;

# Ensure we start in /app
cd /app

# Show ASCII banner
./scripts/ascii_banner.sh

./scripts/systemMetrics.sh
set -e

# Function to check InfluxDB readiness
wait_for_influxdb() {
  echo "Waiting for InfluxDB to be available..."
  until curl -s "${INFLUXDB_URL}/ping" > /dev/null; do
    sleep 1
  done
  echo "InfluxDB is available."
}

wait_for_influxdb

# # Restore previous reports into InfluxDB
# if [ -d "/app/reports/previous_reports" ]; then
#   for report in /app/reports/previous_reports/*.json; do
#     if [ -f "$report" ]; then
#       python /app/python/process_metrics.py --restore "$report"
#     fi
#   done
# fi

# Start metrics collection in the background
#/app/scripts/metrics_to_json.sh &

# Start the Node.js server
node /app/web/server.js

# Keep container alive
tail -f /dev/null
