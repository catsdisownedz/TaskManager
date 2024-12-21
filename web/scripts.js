// Establish a WebSocket connection to the server
const socket = io();

// Function to create a chart
function createChart(ctx, label, color) {
  return new Chart(ctx, {
    type: 'line',
    data: {
      labels: [],
      datasets: [{
        label: label,
        data: [],
        backgroundColor: `${color}33`,
        borderColor: color,
        borderWidth: 2,
        fill: true
      }]
    },
    options: {
      responsive: true,
      scales: {
        x: {
          title: { display: true, text: 'Time' },
          ticks: { color: '#cfcfcf' }
        },
        y: {
          title: { display: true, text: 'Usage' },
          ticks: { color: '#cfcfcf' }
        }
      },
      plugins: {
        legend: {
          labels: { color: '#cfcfcf' }
        }
      }
    }
  });
}

// Grabbing chart elements
const cpuCtx = document.getElementById('cpuChart').getContext('2d');
const memCtx = document.getElementById('memChart').getContext('2d');
const diskCtx = document.getElementById('diskChart').getContext('2d');
const gpuCtx = document.getElementById('gpuChart').getContext('2d');

const cpuChart = createChart(cpuCtx, 'CPU %', getComputedStyle(document.documentElement).getPropertyValue('--cpu-color').trim());
const memChart = createChart(memCtx, 'Memory %', getComputedStyle(document.documentElement).getPropertyValue('--mem-color').trim());
const diskChart = createChart(diskCtx, 'Disk %', getComputedStyle(document.documentElement).getPropertyValue('--disk-color').trim());
const gpuChart = createChart(gpuCtx, 'GPU %', getComputedStyle(document.documentElement).getPropertyValue('--gpu-color').trim());

// Function to update charts with new data
function updateChart(chart, label, dataPoint) {
  chart.data.labels.push(label);
  chart.data.datasets[0].data.push(dataPoint);
  if (chart.data.labels.length > 20) {
    chart.data.labels.shift();
    chart.data.datasets[0].data.shift();
  }
  chart.update();
}

// Handle incoming metric updates from the server
socket.on('metrics_update', (data) => {
  const timeLabel = new Date(data.timestamp).toLocaleTimeString();

  // Update CPU chart
  updateChart(cpuChart, timeLabel, parseFloat(data.cpu.usage));

  // Update Memory chart
  const memoryUsagePercent = (parseFloat(data.RAM.used) / parseFloat(data.RAM.total)) * 100;
  updateChart(memChart, timeLabel, memoryUsagePercent);

  // Update Disk chart
  const diskUsagePercent = (parseFloat(data.Disk.used) / parseFloat(data.Disk.total)) * 100;
  updateChart(diskChart, timeLabel, diskUsagePercent);

  // Update GPU chart (if GPU data is available)
  if (data.gpu && data.gpu.usage) {
    updateChart(gpuChart, timeLabel, parseFloat(data.gpu.usage));
  }

  // Update chart details if a chart is expanded
  updateChartDetails(data);
});

// Chart magnification and details
const chartBoxes = document.querySelectorAll('.chart-box');
let activeChart = null;

chartBoxes.forEach(box => {
  box.addEventListener('click', () => {
    // If this box is already active, deactivate
    if (activeChart === box) {
      box.classList.remove('active-chart');
      activeChart = null;
    } else {
      // Deactivate previous
      if (activeChart) activeChart.classList.remove('active-chart');
      // Activate this one
      box.classList.add('active-chart');
      activeChart = box;
    }
  });
});

function updateChartDetails(data) {
  if (!activeChart) return;

  const details = activeChart.querySelector('.chart-details');
  const chartType = activeChart.getAttribute('data-chart');

  details.innerHTML = '';

  if (chartType === 'cpu') {
    details.innerHTML = `
      <p>Usage: ${data.cpu.usage}%</p>
      <p>Temp: ${data.cpu.temperature || 'N/A'}°C</p>
    `;
  } else if (chartType === 'memory') {
    details.innerHTML = `
      <p>Memory Used: ${data.RAM.used} of ${data.RAM.total}</p>
    `;
  } else if (chartType === 'disk') {
    details.innerHTML = `
      <p>Disk Used: ${data.Disk.used} of ${data.Disk.total}</p>
    `;
  } else if (chartType === 'gpu') {
    details.innerHTML = `
      <p>GPU Usage: ${data.gpu.usage || 'N/A'}%</p>
    `;
  }
}

// Generate Report Button
const generateReportBtn = document.getElementById('generateReportBtn');
generateReportBtn.addEventListener('click', async () => {
  const response = await fetch('/generate_report', { method: 'POST' });
  if (response.ok) {
    alert('Report generated successfully!');
  } else {
    alert('Failed to generate report.');
  }
});
