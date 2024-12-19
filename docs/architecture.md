# Architecture Overview

**What is this file?**
- Describes how components connect and flow.

## Components:
- **Scripts:** Collect system metrics, set up DB, generate reports.
- **Python (process_data.py):** Query InfluxDB for historical data.
- **InfluxDB:** Stores time-series metrics.
- **Zenity GUI:** Provides interactive menus and submenus.
- **Docker:** Ensures reproducible environment and handles setup automatically.

## Data Flow:
1. On startup, `entrypoint.sh` runs:
   - `setup_influxdb.sh` to create the DB.
   - `run_all.sh` to collect metrics and store them in logs and InfluxDB.
   - `generate_reports.sh` to produce Markdown and HTML reports.
   - `dashboard.sh` to launch the GUI.
2. GUI allows browsing real-time and historical metrics.
3. Python script provides historical queries to GUI when requested.

All is automated for user convenience.
