const express = require('express');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const app = express();

// Serve static files
app.use(express.static('web'));
app.use(express.json());

// Path to metrics file
const metricsFilePath = path.join(__dirname, '../scripts/json_metrics.json');

// Generate metrics every 5 seconds
function updateMetrics() {
  exec('/app/scripts/update_metrics.sh', (error) => {
    if (error) {
      console.error('Error updating metrics:', error);
    } else {
      console.log('Metrics updated successfully.');
    }
  });
}

// Call updateMetrics every 5 seconds
setInterval(updateMetrics, 5000);

// API endpoint to fetch metrics
app.get('/metrics', (req, res) => {
  fs.readFile(metricsFilePath, 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading metrics file:', err);
      return res.status(500).json({ error: 'Metrics file not found' });
    }
    res.header('Content-Type', 'application/json');
    res.send(data);
  });
});

// Generate HTML report endpoint
app.post('/generate_report', (req, res) => {
  exec('/app/scripts/generate_html_report.sh', (error) => {
    if (error) {
      console.error('Error generating report:', error);
      return res.status(500).json({ error: 'Failed to generate report' });
    }
    res.json({ message: 'Report generated successfully' });
  });
});

// API endpoint to fetch reports
app.get('/reports', (req, res) => {
  const reportsDir = path.join(__dirname, '../reports/html');
  fs.readdir(reportsDir, (err, files) => {
    if (err) {
      return res.json([]);
    }
    const htmlReports = files.filter(f => f.endsWith('.html'));
    const reportsWithTime = htmlReports.map(filename => {
      const match = filename.match(/report_(\d{8})_(\d{6})\.html/);
      if (match) {
        const datePart = match[1];
        const timePart = match[2];
        const year = datePart.slice(0, 4);
        const month = datePart.slice(4, 6);
        const day = datePart.slice(6, 8);
        const hour = timePart.slice(0, 2);
        const min = timePart.slice(2, 4);
        const sec = timePart.slice(4, 6);
        const dateObj = new Date(`${year}-${month}-${day}T${hour}:${min}:${sec}Z`);
        return { filename, time: dateObj.toISOString() };
      } else {
        return { filename, time: '' };
      }
    });
    reportsWithTime.sort((a, b) => new Date(b.time) - new Date(a.time));
    res.json(reportsWithTime);
  });
});

// Endpoint to fetch individual report
app.get('/reports/:filename', (req, res) => {
  const reportsDir = path.join(__dirname, '../reports/html');
  const filePath = path.join(reportsDir, req.params.filename);
  fs.exists(filePath, (exists) => {
    if (!exists) return res.status(404).send('Report not found');
    res.sendFile(filePath);
  });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
