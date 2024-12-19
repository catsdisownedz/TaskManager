#!/usr/bin/env bash
# generate_reports.sh
# Generates both Markdown and HTML reports automatically at startup.

./../reports/generate_markdown_report.sh > ../reports/latest_report.md
./../reports/generate_html_report.sh > ../reports/latest_report.html
