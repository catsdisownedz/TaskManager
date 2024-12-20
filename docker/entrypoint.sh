#!/usr/bin/env bash
# entrypoint.sh
# Runs when the container starts.

# Ensure we start in /app
cd /app

# Show ASCII banner
./scripts/ascii_banner.sh

# If you needed InfluxDB setup (commented out now)
# ./scripts/setup_influxdb.sh

# Run initial metrics collection from /app
./scripts/run_all.sh

# Update metrics.json periodically from /app
while true; do
  ./scripts/metrics_to_json.sh
  sleep 5
done &

# Start Node.js server from /app
node web/server.js &

# Generate initial reports from /app
./scripts/generate_reports.sh

# Launch GUI dashboard from /app
./dashboard/dashboard.sh

# Keep container alive
tail -f /dev/null
