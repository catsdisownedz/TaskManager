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

const writeOptions = {
  maxRetries: 5, // Maximum number of retry attempts
  retryJitter: 200, // Jitter in milliseconds added to retry delay to prevent thundering herd problem
  maxRetryDelay: 125000, // Maximum delay between retries in milliseconds
  minRetryDelay: 5000, // Minimum delay between retries in milliseconds
};

// Initialize InfluxDB client
const influxDB = new InfluxDB({ url, token });
const writeApi = influxDB.getWriteApi(org, bucket, 'ns', writeOptions);

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
            const metrics = JSON.parse(stdout.trim()); // Remove extra spaces/newlines
            const point = new Point('system_metrics')
                .timestamp(new Date(metrics.timestamp))
                .floatField('cpu_usage', parseFloat(metrics.cpu.usage))
                .floatField('disk_used', parseFloat(metrics.Disk.used))
                .floatField('disk_total', parseFloat(metrics.Disk.total))
                .floatField('ram_used', parseFloat(metrics.RAM.used))
                .floatField('ram_total', parseFloat(metrics.RAM.total));

            writeApi.writePoint(point);
            logger.info(`Point written: ${point}`);

            io.emit('metrics_update', metrics);
            logger.info('Metrics processed and emitted successfully');
        } catch (parseError) {
            logger.error(`Error parsing metrics: ${parseError.message}`);
        }
    });
}


setInterval(collectAndProcessMetrics, 1000);

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
        |> filter(fn: (r) => r._measurement == "system_metrics")
        |> keep(columns: ["_time", "cpu_usage", "disk_used", "disk_total", "ram_used", "ram_total"])
        |> sort(columns: ["_time"], desc: true)
    `;

    const reports = [];
    await queryApi.queryRows(fluxQuery, {
      next(row, tableMeta) {
        const data = tableMeta.toObject(row);
        reports.push({
          timestamp: data._time,
          cpu_usage: data.cpu_usage || 'N/A',
          disk_used: data.disk_used || 'N/A',
          disk_total: data.disk_total || 'N/A',
          ram_used: data.ram_used || 'N/A',
          ram_total: data.ram_total || 'N/A',
        });
      },
      error(error) {
        logger.error(`Error querying InfluxDB: ${error.message}`);
        res.status(500).json({ error: "Failed to fetch reports from the database" });
      },
      complete() {
        logger.info(`Reports fetched: ${JSON.stringify(reports)}`);
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


//.floatField('cpu_temperature', parseFloat(metrics.cpu.temperature))