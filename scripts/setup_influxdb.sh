#!/usr/bin/env bash
# setup_influxdb.sh
# Ensures InfluxDB database is created before we start collecting.

# # Wait for InfluxDB to be ready
# sleep 5

# # Create the database 'metrics' if it doesn't exist
# curl -s -XPOST 'http://influxdb:8086/query' --data-urlencode "q=CREATE DATABASE metrics" > /dev/null

