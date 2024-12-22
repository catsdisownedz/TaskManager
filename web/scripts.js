
// Establish a WebSocket connection to the server
const socket = io();
let activeChart = null; 
// Function to create a chart
const createChart = (context, label, data) => {
  return new Chart(context, {
    type: 'doughnut',
    data: {
      labels: [label, 'Unused'],
      datasets: [
        {
          data: [data, 100 - data],
          backgroundColor: ['#FFC0CB', '#EEEEEE'], // Pink for 'Used', light gray for 'Unused'
          borderWidth: 1,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: true },
      },
    },
  });
};

// Grabbing chart elements
const cpuCtx = document.getElementById('cpuChart').getContext('2d');
const memCtx = document.getElementById('memChart').getContext('2d');
const diskCtx = document.getElementById('diskChart').getContext('2d');
const gpuCtx = document.getElementById('gpuChart').getContext('2d');

// Creating charts
const cpuChart = createChart(cpuCtx, 'CPU %', getComputedStyle(document.documentElement).getPropertyValue('--cpu-color').trim());
const memChart = createChart(memCtx, 'Memory %', getComputedStyle(document.documentElement).getPropertyValue('--mem-color').trim());
const diskChart = createChart(diskCtx, 'Disk %', getComputedStyle(document.documentElement).getPropertyValue('--disk-color').trim());
const gpuChart = createChart(gpuCtx, 'GPU %', getComputedStyle(document.documentElement).getPropertyValue('--gpu-color').trim());

// Function to update charts with new data
const updateChart = (chart, label, value, total = 100) => {
  const usedValue = Math.max(0, parseFloat(value) || 0); // Ensure value is numeric
  const totalValue = Math.max(usedValue, parseFloat(total) || 100); // Total must >= used
  const unusedValue = Math.max(0, totalValue - usedValue);

  chart.data.labels = [label, 'Unused'];
  chart.data.datasets[0].data = [usedValue, unusedValue];
  chart.update();
};

// Handle incoming metric updates from the server
socket.on('metrics_update', (data) => {
  console.log('Received metrics update:', data);
  // Update CPU chart
  updateChart(cpuChart, 'CPU Usage', parseFloat(data.cpu.usage));

  // Update Memory chart
  const memoryUsagePercent = (parseFloat(data.RAM.used) / parseFloat(data.RAM.total)) * 100;
  updateChart(memChart, 'Memory Usage', memoryUsagePercent);

  // Update Disk chart
  const diskUsagePercent = (parseFloat(data.Disk.used) / parseFloat(data.Disk.total)) * 100;
  updateChart(diskChart, 'Disk Usage', diskUsagePercent);

  // Update GPU chart (if GPU data is available)
  if (data.gpu && data.gpu.usage) {
    updateChart(gpuChart, 'GPU Usage', parseFloat(data.gpu.usage));
  }

  // Update chart details if a chart is expanded
  updateChartDetails(data);
});

// Update detailed information for expanded charts
function updateChartDetails(data) {
  if (!activeChart) return;

  const details = activeChart.querySelector('.chart-details');
  const chartType = activeChart.getAttribute('data-chart');

  details.innerHTML = '';

  if (chartType === 'cpu') {
    details.innerHTML = `
      <p>Usage: ${data.cpu.usage}%</p>
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

// Generate Report Button functionality
const generateReportBtn = document.getElementById('generateReportBtn');
generateReportBtn.addEventListener('click', async () => {
  const response = await fetch('/generate_report', { method: 'POST' });
  if (response.ok) {
    alert('Report generated successfully!');
  } else {
    alert('Failed to generate report.');
  }
});
// <p>Temp: ${data.cpu.temperature || 'N/A'}°C</p>
