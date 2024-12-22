

## **User Guide**

**What is this file?**  
- Explains how to use the system after setup.

---

### **Using the System**

1. **Starting the System**  
   - Once `docker-compose up` is executed:
     - The web dashboard is automatically launched.
     - All background processes for metrics collection and reporting are initiated.

2. **Web Dashboard**  
   - The dashboard is available at `http://localhost:8080`.  
   - Features include:
     - **Real-Time Metrics**: Updates every second.  
     - **Search Functionality**: Search historical data by timestamp.  
     - **Report Generation**: Generate and download detailed reports.  

3. **Zenity GUI**  
   - Access via terminal using the `systemMetrics.sh` script.  
   - Features:
     - **Live Metrics**: Updated every second.  
     - **Historical Data Search**: Enter timestamps to fetch specific data.  
     - **Navigation**: Use "Back" buttons to return to the main menu.  

4. **Reports**  
   - Reports are stored in the `reports/` directory.
   - Formats:
     - **Markdown**: For text-based documentation.  
     - **HTML**: For browser-based visualization.  

5. **No Manual Intervention**  
   - The system runs in the background, continuously collecting and storing metrics.

