require('dotenv').config();

const logger = require('./utils/logger');
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
  logger.info('New client connected via WebSocket');
  socket.on('disconnect', () => {
    logger.info('Client disconnected');
  });
});

function collectAndProcessMetrics() {
  exec('/app/scripts/metrics_to_json.sh', (error, stdout, stderr) => {
    if (error) {
      logger.error(`Error executing script: ${error.message}`);
      return;
    }
    if (stderr) {
      logger.error(`Script error output: ${stderr}`);
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
      logger.info('Metrics processed and emitted successfully');
    } catch (parseError) {
      logger.error(`Error parsing metrics: ${parseError.message}`);
    }
  });
}

setInterval(collectAndProcessMetrics, 5000);

process.on('exit', () => {
  writeApi.close().then(() => {
    logger.info('InfluxDB write API closed');
  }).catch((error) => {
    logger.error(`Error closing InfluxDB write API: ${error.message}`);
  });
});

app.post('/generate_report', (req, res) => {
  exec('/app/scripts/generate_html_report.sh', (error) => {
    if (error) {
      logger.error('Error generating report:', error.message);
      return res.status(500).json({ error: 'Failed to generate report' });
    }
    logger.info('Report generated successfully');
    res.json({ message: 'Report generated successfully' });
  });
});

app.get('/reports', async (req, res) => {
  try {
    const queryApi = influxDB.getQueryApi(org);
    const fluxQuery = `
      from(bucket: "${bucket}")
        |> range(start: -30d)
        |> filter(fn: (r) => r._measurement == "report_metrics")
        |> group(columns: ["filename", "_time"])
        |> sort(columns: ["_time"], desc: true)
    `;

    const reports = [];
    await queryApi.queryRows(fluxQuery, {
      next(row, tableMeta) {
        const data = tableMeta.toObject(row);
        reports.push({
          filename: data.filename,
          time: data._time,
        });
      },
      error(error) {
        logger.error(`Error querying InfluxDB: ${error.message}`);
        res.status(500).json({ error: "Failed to fetch reports from the database" });
      },
      complete() {
        logger.info('Reports successfully fetched from InfluxDB');
        res.json(reports);
      },
    });
  } catch (error) {
    logger.error(`Unexpected error fetching reports: ${error.message}`);
    res.status(500).json({ error: "Failed to fetch reports" });
  }
});


// Start the server
const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});
