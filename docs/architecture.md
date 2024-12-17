# Architecture Overview

## Components
- **Scripts**: Collect system metrics and log them.
- **Dashboard**: Uses whiptail to present an interactive menu to the user.
- **Reports**: Generates markdown and HTML reports from collected metrics.
- **Docker**: Encapsulates the environment and makes the system portable.

## Data Flow
1. `run_all.sh` triggers metric collection scripts.
2. Metrics are logged into `data/logs/system_metrics.log`.
3. Reports and dashboard queries read from logs and/or historical DB.
4. Docker environment ensures reproducibility.
