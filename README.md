# System Monitoring Project

**What is this file?**  
- High-level overview of the entire project.

This system monitoring solution:
- Automatically sets up and runs when `docker-compose up` is executed.
- Collects CPU, GPU, Memory, Disk, Network, and Load metrics.
- Stores data in InfluxDB and logs.
- Generates Markdown and HTML reports automatically.
- Provides a Zenity GUI with:
  - Live-updating stats, refreshed every second.
  - Historical data search by timestamp.
  - Navigation between menus and submenus.
  - Typewriter font and colored text styling.
- Python is used for advanced processing and querying InfluxDB for historical data.
- A custom ASCII banner is displayed in the terminal for aesthetics.

For installation and usage instructions, see:
- [docs/installation.md](docs/installation.md)
- [docs/user_guide.md](docs/user_guide.md)
- [docs/architecture.md](docs/architecture.md)
