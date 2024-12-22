Here’s an updated version of your README based on the additional context about your project:

---

# **System Monitoring and Reporting Project**

**What is this file?**  
- A high-level overview of the entire project, designed to monitor system performance, store data, and generate actionable insights.

---

## **Overview**

This project is a real-time system monitoring solution designed for efficient data collection, storage, visualization, and reporting. It combines **Node.js**, **InfluxDB**, and **Zenity** for robust functionality, including live dashboards, historical data analysis, and visually appealing UI elements.

### **Key Features**
1. **Automated Setup**  
   - Instantly runs with a single `docker-compose up` command.
   - Containerized environment using Docker ensures portability and ease of deployment.

2. **Metric Collection**  
   - Collects detailed system performance metrics, including:
     - **CPU**: Usage percentage.
     - **GPU**: Utilization metrics (if available).
     - **Memory**: Used and total memory.
     - **Disk**: Used and total storage.
     - **Network**: Bandwidth and traffic analysis (future scope).
     - **Load**: System load averages.
   - Metrics are captured every second via a combination of `bash` scripts and Node.js.

3. **Data Storage and Retrieval**  
   - Data is stored in **InfluxDB**, enabling:
     - Real-time updates for monitoring dashboards.
     - Historical data querying using Flux queries.
   - InfluxDB **buckets** and **measurements** are consistently organized for ease of access.

4. **Live Dashboard**  
   - Web-based interface with:
     - **Doughnut charts** for CPU, Memory, Disk, and GPU usage.
     - Real-time updates using WebSockets (`socket.io`).
     - Filterable reports with a search-by-timestamp feature.
   - Powered by Node.js with a clean UI design.

5. **Historical Data and Reporting**  
   - **HTML and Markdown reports**:
     - Automatically generated via a dedicated script (`generate_html_report.sh`).
     - Can be downloaded for further analysis.
   - Historical data is fetched and visualized from InfluxDB.

6. **Zenity GUI Integration**  
   - Features a graphical interface with:
     - Live stats refreshed every second.
     - Menus for easy navigation and submenus for specific metrics.
     - Searchable historical data by timestamps.
   - Aesthetics include typewriter fonts and color-coded text.

7. **Error Handling and Logging**  
   - Robust error handling for database queries and metric collection.
   - Logs for debugging and monitoring in both the server and client layers.

---

## **Core Technologies**
- **Backend**: Node.js (Express.js, Socket.IO)
- **Database**: InfluxDB (with Flux query language)
- **Frontend**: WebSocket-based live dashboard
- **Scripts**: Bash for metrics collection and automation
- **Visualization**: Charts.js for real-time data visualization
- **Reporting**: Automated Markdown and HTML generation
- **GUI**: Zenity for an interactive desktop-based experience

---

## **Architecture**
The project architecture is modular and extensible:
1. **Dockerized Environment**  
   - All services (Node.js, InfluxDB) run in isolated containers.
   - Configuration via `.env` ensures flexibility and environment-specific adjustments.

2. **Data Flow**  
   - **Metric Collection**: Bash scripts collect raw data.
   - **Storage**: Data is written to InfluxDB as points under specific measurements.
   - **Retrieval**: Historical and real-time data is fetched via Flux queries.
   - **Visualization**: Web and Zenity GUIs display data dynamically.

3. **Real-Time and Historical Components**  
   - Real-time metrics are streamed to the dashboard using WebSockets.
   - Historical data is retrieved from InfluxDB for reporting and analysis.

---

## **Setup and Usage**
1. **Requirements**
   - Docker and Docker Compose
   - A modern web browser for the dashboard
   - Linux-based system for Zenity GUI integration

2. **Installation**
   - Clone the repository.
   - Configure the `.env` file for your InfluxDB URL, token, org, and bucket.
   - Run `docker-compose up`.

3. **Accessing the Dashboard**
   - Visit `http://localhost:8080` for the live monitoring dashboard.
   - Use the search bar to filter reports by timestamp.

4. **Zenity GUI**
   - Run `zenity_gui.sh` for a graphical interface to live and historical data.

---

## **Future Enhancements**
- **Additional Metrics**: Add advanced network and GPU monitoring.
- **Notifications**: Alerts for threshold breaches.
- **Extended Reporting**: Support for additional formats like CSV and PDF.
- **Cross-Platform GUI**: Extend Zenity GUI capabilities to macOS and Windows.

---

## **Documentation**
For more details, refer to:
- [Installation Guide](docs/installation.md)
- [User Guide](docs/user_guide.md)
- [Architecture Overview](docs/architecture.md)

---

## **Contributing**
Contributions are welcome! Please submit issues or pull requests to improve the project.

---

This updated README should clearly explain the project's features and functionality while reflecting the current state of your system monitoring solution.