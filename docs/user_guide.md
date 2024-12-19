
**project/docs/user_guide.md**
```markdown
# User Guide

**What is this file?**
- Explains how to use the system after setup.

    Once containers are up:
    - The dashboard will run automatically.
    - Use the GUI menus to:
    - View live metrics (updates every second).
    - Generate and view reports (Markdown/HTML).
    - Search historical data by entering timestamps.
    - Use "Back" buttons to return to the main menu.
    - The system continuously collects data in the background.

    Reports are stored in `reports/` directory. Historical data queries are handled by Python and InfluxDB. No manual intervention needed.

    That's it! Just run `docker-compose up` and enjoy the experience.
