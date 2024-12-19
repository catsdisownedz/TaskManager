# Installation Instructions

**What is this file?**  
This file explains how to install and run the system.

## Steps

1. **Prerequisites:**  
   - Ensure you have `git`, `docker`, and `docker-compose` installed on your host system.
   - If you plan to run the Zenity GUI, ensure you have a desktop environment and Zenity installed on the host. Alternatively, run `docker` with a GUI forwarding setup or run the dashboard locally outside the container.

2. **Clone the Repository:**  
   ```bash
   git clone https://github.com/catsdisownedz/TaskManager
   ```
3. **Navigate to the project directory**

4. **Build and run the Docker Containers:**
   ```bash
   docker-compose up -d
   ```

5. **Acessing the Dashboard:**
   ```bash