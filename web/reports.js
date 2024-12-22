// Function to fetch reports from the server
async function fetchReports() {
  try {
    console.log('Fetching reports from the server...');
    const res = await fetch('/reports');
    if (!res.ok) {
      throw new Error('Failed to fetch reports');
    }
    const reports = await res.json();
    console.log(`Fetched ${reports.length} reports successfully.`);
    return reports;
  } catch (error) {
    console.error(`Error fetching reports: ${error.message}`);
    return [];
  }
}

// Function to refresh the displayed reports
async function refreshReports() {
  console.log('Refreshing reports...');
  const reports = await fetchReports();
  displayReports(reports);
}

// Function to filter reports based on a search query, including timestamps
function filterReports(query) {
  console.log(`Filtering reports with query: "${query}"`);
  const items = document.querySelectorAll('#reportUl li');
  items.forEach((item) => {
    const text = item.textContent.toLowerCase();
    const timestamp = item.getAttribute('data-timestamp') || ''; // Get the timestamp attribute
    item.style.display =
      text.includes(query.toLowerCase()) || timestamp.includes(query.toLowerCase()) ? '' : 'none';
  });
  console.log('Reports filtered successfully.');
}

// Function to display the fetched reports in the UI, including timestamps for search
function displayReports(reports) {
  console.log('Displaying reports in the UI...');
  const reportUl = document.getElementById('reportUl');
  reportUl.innerHTML = '';
  reports.forEach((r) => {
    const li = document.createElement('li');
    li.setAttribute('data-timestamp', new Date(r.time).toLocaleString().toLowerCase()); // Store timestamp as an attribute
    const link = document.createElement('a');
    link.href = `/reports/${r.filename}`;
    link.target = '_blank';
    link.textContent = `${r.filename} (${new Date(r.time).toLocaleString()})`;
    li.appendChild(link);
    reportUl.appendChild(li);
  });
  console.log('Reports displayed successfully.');
}

// Add an event listener to the search input for filtering reports
const searchInput = document.getElementById('searchInput');
searchInput.addEventListener('input', () => {
  const query = searchInput.value;
  console.log(`Search input changed: "${query}"`);
  filterReports(query);
});

// Initial load of reports
console.log('Initializing report fetch...');
refreshReports();
