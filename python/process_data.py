#!/usr/bin/env python3
"""
process_data.py
Queries InfluxDB for historical data.
Allows searching by timestamp range to retrieve metrics.

Usage:
- Called from the dashboard scripts when user wants historical data.
- It prints results in a simple text format for Zenity to display.
"""

# from influxdb import InfluxDBClient
# import sys

# # InfluxDB connection settings
# client = InfluxDBClient(host='influxdb', port=8086, database='metrics')

# def query_data(start_time, end_time):
#     """
#     Query CPU usage between start_time and end_time.
#     start_time and end_time should be InfluxDB-compatible timestamps, for example:
#     '2024-12-17T00:00:00Z' or 'now() - 1h'
#     """
#     query = f"SELECT value FROM cpu_usage WHERE time >= '{start_time}' AND time <= '{end_time}'"
#     result = client.query(query)
#     points = list(result.get_points(measurement='cpu_usage'))
#     return points

# if __name__ == "__main__":
#     if len(sys.argv) < 3:
#         print("Please provide start and end timestamps. Example: 2024-12-17T00:00:00Z 2024-12-17T01:00:00Z")
#         sys.exit(1)

#     start = sys.argv[1]
#     end = sys.argv[2]

#     data = query_data(start, end)
#     if not data:
#         print("No data found in the given range.")
#     else:
#         print("CPU Usage (timestamp | value):")
#         for point in data:
#             print(f"{point['time']} | {point['value']:.2f}%")
