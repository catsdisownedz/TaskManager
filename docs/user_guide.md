# User Guide

## Running the Scripts
- To collect metrics:
    `./scripts/run_all.sh`
- To view the dashboard:
    `./dashboard/dashboard.sh`


## Generating Reports
- Markdown report:
    `./reports/generate_markdown_report.sh > report.md`
- HTML report:
    `./reports/generate_html_report.sh > report.html`


## Historical Data
Historical metrics and logs are stored in `data/logs` and `data/historical_data.db`. You can also configure InfluxDB if desired.
