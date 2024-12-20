async function fetchMetrics() {
  const response = await fetch('/metrics');
  const data = await response.json();
  return data;
}

function createChart(ctx, label, color) {
  return new Chart(ctx, {
    type: 'line',
    data: {
      labels: [],
      datasets: [{
        label: label,
        data: [],
        backgroundColor: color + '33',
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

async function updateCharts() {
  const data = await fetchMetrics();
  
  const timeLabel = new Date(data.timestamp).toLocaleTimeString();

  // CPU chart
  cpuChart.data.labels.push(timeLabel);
  cpuChart.data.datasets[0].data.push(data.cpu.usage); 
  if (cpuChart.data.labels.length > 20) {
    cpuChart.data.labels.shift();
    cpuChart.data.datasets[0].data.shift();
  }
  cpuChart.update();

  // Memory chart
  memChart.data.labels.push(timeLabel);
  // Assume data.memory is a numeric usage %
  memChart.data.datasets[0].data.push(parseFloat(data.memory_usage || 0));
  if (memChart.data.labels.length > 20) {
    memChart.data.labels.shift();
    memChart.data.datasets[0].data.shift();
  }
  memChart.update();

  // Disk chart
  diskChart.data.labels.push(timeLabel);
  diskChart.data.datasets[0].data.push(parseFloat(data.disk || 0));
  if (diskChart.data.labels.length > 20) {
    diskChart.data.labels.shift();
    diskChart.data.datasets[0].data.shift();
  }
  diskChart.update();

  // GPU chart
  gpuChart.data.labels.push(timeLabel);
  gpuChart.data.datasets[0].data.push(parseFloat(data.gpu || 0));
  if (gpuChart.data.labels.length > 20) {
    gpuChart.data.labels.shift();
    gpuChart.data.datasets[0].data.shift();
  }
  gpuChart.update();

  // Update details if a chart is expanded
  updateChartDetails(data);
}

setInterval(updateCharts, 5000);

// Chart Magnification and Details
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
  // data structure assumed:
  // {
  //   "timestamp": "2024-12-19T15:54:00Z",
  //   "cpu": { "usage": 39, "temperature": 60 },
  //   "memory": ...,
  //   "disk": ...,
  //   "gpu": ...
  // }

  if (!activeChart) return;

  const details = activeChart.querySelector('.chart-details');
  const chartType = activeChart.getAttribute('data-chart');

  details.innerHTML = ''; 

  if (chartType === 'cpu') {
    details.innerHTML = `
      <p>Usage: ${data.cpu.usage}%</p>
      <p>Temp: ${data.cpu.temperature || 'N/A'}°C</p>
      <p>Processes: ${data.processes || 'N/A'}</p>
    `;
  } else if (chartType === 'memory') {
    details.innerHTML = `
      <p>Memory Used: ${data.memory}</p>
    `;
  } else if (chartType === 'disk') {
    details.innerHTML = `
      <p>Disk Usage: ${data.disk}</p>
    `;
  } else if (chartType === 'gpu') {
    details.innerHTML = `
      <p>GPU Usage: ${data.gpu}</p>
    `;
  }
}

// Generate Report Button
const generateReportBtn = document.getElementById('generateReportBtn');
generateReportBtn.addEventListener('click', async () => {
  await fetch('/generate_report', { method: 'POST' });
  alert('Report generated successfully!');
});
