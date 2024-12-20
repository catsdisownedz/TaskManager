#!/usr/bin/env bash
# generate_reports.sh
# Generates both Markdown and HTML reports automatically at startup.

./scripts/generate_markdown_report.sh > ./reports/markdown/latest_report.md
./scripts/generate_html_report.sh > ./reports/html/latest_report.html
