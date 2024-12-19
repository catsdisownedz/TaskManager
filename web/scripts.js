async function fetchMetrics() {
    const response = await fetch('/metrics');
    const data = await response.json();
    return data;
  }
  
  function createChart(ctx, label, color) {
    return new Chart(ctx, {
      type: 'line',
      data: {
        labels: [], //da hyb2a updated kol shwaya
        datasets: [{
          label: label,
          data: [],
          backgroundColor: color + '33', //da hy5leeh transparent
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
  
  // hena el animations bta3et el charts so far 
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
    
    //da if we are assuming en el data htb2a 7aga zy keda:
    // {
    //   "timestamp": "2024-12-19T15:54:00Z",
    //   "cpu": 39,
    //   "memory": 83,
    //   "disk": 1,
    //   "gpu": 22
    // }
    
    const timeLabel = new Date(data.timestamp).toLocaleTimeString();
    
    //da el bey-update el cpu chart
    cpuChart.data.labels.push(timeLabel);
    cpuChart.data.datasets[0].data.push(data.cpu);
    if (cpuChart.data.labels.length > 20) {
      cpuChart.data.labels.shift();
      cpuChart.data.datasets[0].data.shift();
    }
    cpuChart.update();
    
    //da el memory chart
    memChart.data.labels.push(timeLabel);
    memChart.data.datasets[0].data.push(data.memory);
    if (memChart.data.labels.length > 20) {
      memChart.data.labels.shift();
      memChart.data.datasets[0].data.shift();
    }
    memChart.update();

        //disk
    diskChart.data.labels.push(timeLabel);
    diskChart.data.datasets[0].data.push(data.disk);
    if (diskChart.data.labels.length > 20) {
        diskChart.data.labels.shift();
        diskChart.data.datasets[0].data.shift();
    }
    diskChart.update();

    //gpu
    gpuChart.data.labels.push(timeLabel);
    gpuChart.data.datasets[0].data.push(data.gpu);
    if (gpuChart.data.labels.length > 20) {
        gpuChart.data.labels.shift();
        gpuChart.data.datasets[0].data.shift();
    }
    gpuChart.update();
  }
  
  setInterval(updateCharts, 5000); //update kol 5 secs, alter here 
  





  // di el section el tb3 el reports lama badoos 3l buttons 
  const generateReportBtn = document.getElementById('generateReportBtn');
  const toggleReportsBtn = document.getElementById('toggleReportsBtn');
  const searchInput = document.getElementById('searchInput');
  const reportListDiv = document.getElementById('reportList');
  const reportUl = document.getElementById('reportUl');
  
  generateReportBtn.addEventListener('click', async () => {
    await fetch('/generate_report', { method: 'POST' });
    refreshReports();
    //api endpoint hb3tlha el reports 
  });
  
  toggleReportsBtn.addEventListener('click', () => {
    if (reportListDiv.style.display === 'none') {
      reportListDiv.style.display = 'block';
      refreshReports();
    } else {
      reportListDiv.style.display = 'none';
    }
  });
  
  searchInput.addEventListener('input', () => {
    filterReports(searchInput.value);
  });
  
  async function fetchReports() {
    const res = await fetch('/reports');
    return res.json();
  }
  
  async function refreshReports() {
    const reports = await fetchReports();
    displayReports(reports);
  }
  
  function displayReports(reports) {
    reportUl.innerHTML = '';
    reports.forEach(r => {
      const li = document.createElement('li');
      const link = document.createElement('a');
      link.href = `/reports/${r.filename}`;
      link.target = '_blank';
      link.textContent = `${r.filename} (${r.time})`;
      li.appendChild(link);
      reportUl.appendChild(li);
    });
  }
  
  function filterReports(query) {
    const items = reportUl.querySelectorAll('li');
    items.forEach(item => {
      const text = item.textContent.toLowerCase();
      if (text.includes(query.toLowerCase())) {
        item.style.display = '';
      } else {
        item.style.display = 'none';
      }
    });
  }
  
  //automatically refresh the report list every 30 seconds if visible
  setInterval(() => {
    if (reportListDiv.style.display !== 'none') {
      refreshReports();
    }
  }, 30000);
