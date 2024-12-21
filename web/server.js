require('dotenv').config();
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const { InfluxDB, Point } = require('@influxdata/influxdb-client');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const metricsFilePath = path.join(__dirname, '../scripts/json_metrics.json');

const url = process.env.INFLUXDB_URL;
const token = process.env.INFLUXDB_TOKEN;
const org = process.env.INFLUXDB_ORG;
const bucket = process.env.INFLUXDB_BUCKET;

// Initialize InfluxDB client
const influxDB = new InfluxDB({ url, token });
const writeApi = influxDB.getWriteApi(org, bucket, 'ns');

app.use(express.static('web'));
app.use(express.json());



io.on('connection', (socket) => {
  console.log('New client connected');
  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

function collectAndProcessMetrics() {
  exec('/app/scripts/metrics_to_json.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing script: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`Script error output: ${stderr}`);
      return;
    }
    try {
      const metrics = JSON.parse(stdout);
      const point = new Point('system_metrics')
        .timestamp(new Date(metrics.timestamp))
        .floatField('cpu_usage', parseFloat(metrics.cpu.usage))
        .floatField('cpu_temperature', parseFloat(metrics.cpu.temperature))
        .floatField('disk_used', parseFloat(metrics.Disk.used))
        .floatField('disk_total', parseFloat(metrics.Disk.total))
        .floatField('ram_used', parseFloat(metrics.RAM.used))
        .floatField('ram_total', parseFloat(metrics.RAM.total));

      writeApi.writePoint(point);
      io.emit('metrics_update', metrics);
      console.log('Metrics processed and emitted successfully.');
    } catch (parseError) {
      console.error(`Error parsing metrics: ${parseError.message}`);
    }
  });
}

setInterval(collectAndProcessMetrics, 5000);

process.on('exit', () => {
  writeApi.close().then(() => {
    console.log('InfluxDB write API closed.');
  }).catch((error) => {
    console.error(`Error closing InfluxDB write API: ${error.message}`);
  });
});


app.post('/generate_report', (req, res) => {
  exec('/app/scripts/generate_html_report.sh', (error) => {
    if (error) {
      console.error('Error generating report:', error);
      return res.status(500).json({ error: 'Failed to generate report' });
    }
    res.json({ message: 'Report generated successfully' });
  });
});

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

app.get('/reports/:filename', (req, res) => {
  const reportsDir = path.join(__dirname, '../reports/html');
  const filePath = path.join(reportsDir, req.params.filename);
  fs.exists(filePath, (exists) => {
    if (!exists) return res.status(404).send('Report not found');
    res.sendFile(filePath);
  });
});

// Start the server
const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
