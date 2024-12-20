async function fetchReports() {
    const res = await fetch('/reports');
    return res.json();
  }
  
  async function refreshReports() {
    const reports = await fetchReports();
    displayReports(reports);
  }
  
  function displayReports(reports) {
    const reportUl = document.getElementById('reportUl');
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
    const items = document.querySelectorAll('#reportUl li');
    items.forEach(item => {
      const text = item.textContent.toLowerCase();
      item.style.display = text.includes(query.toLowerCase()) ? '' : 'none';
    });
  }
  
  const searchInput = document.getElementById('searchInput');
  searchInput.addEventListener('input', () => {
    filterReports(searchInput.value);
  });
  
  // Initial load
  refreshReports();

  
  // Example: toggling expanded class
  li.addEventListener('click', () => {
    li.classList.toggle('expanded');
  });
  