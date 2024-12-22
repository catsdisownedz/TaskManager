## **Installation Instructions**

**What is this file?**  
- Provides step-by-step instructions to install and run the system.

---

### **Steps**

1. **Prerequisites**  
   - Install the following on your host machine:
     - `git`
     - `docker`
     - `docker-compose`  
   - **For GUI Support**:
     - Ensure `zenity` is installed if you plan to use the Zenity GUI.  
     - On headless systems, configure Docker to support GUI forwarding.  

2. **Clone the Repository**  
   ```bash
   git clone https://github.com/catsdisownedz/TaskManager.git
   cd TaskManager
   ```

3. **Build and Run the Docker Containers**  
   ```bash
   docker-compose up -d
   ```

4. **Access the System**  
   - **Web Dashboard**: Visit `http://localhost:8080` in your browser.  
   - **Zenity GUI**: Run the GUI by executing:  
     ```bash
     docker exec -it <container_name> /app/scripts/zenity_gui.sh
     ```

5. **View Reports**  
   - Reports (Markdown and HTML) are stored in the `reports/` directory.  
   - Access them via the dashboard or directly from the file system.

