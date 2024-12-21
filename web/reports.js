// Import the logger.js module
import logger from './utils/logger.js';

// Function to fetch reports from the server
async function fetchReports() {
  try {
    logger.info('Fetching reports from the server...');
    const res = await fetch('/reports');
    if (!res.ok) {
      throw new Error('Failed to fetch reports');
    }
    const reports = await res.json();
    logger.info(`Fetched ${reports.length} reports successfully.`);
    return reports;
  } catch (error) {
    logger.error(`Error fetching reports: ${error.message}`);
    return [];
  }
}

// Function to refresh the displayed reports
async function refreshReports() {
  logger.info('Refreshing reports...');
  const reports = await fetchReports();
  displayReports(reports);
}

// Function to display the fetched reports in the UI
function displayReports(reports) {
  logger.info('Displaying reports in the UI...');
  const reportUl = document.getElementById('reportUl');
  reportUl.innerHTML = '';
  reports.forEach((r) => {
    const li = document.createElement('li');
    const link = document.createElement('a');
    link.href = `/reports/${r.filename}`;
    link.target = '_blank';
    link.textContent = `${r.filename} (${new Date(r.time).toLocaleString()})`;
    li.appendChild(link);
    reportUl.appendChild(li);
  });
  logger.info('Reports displayed successfully.');
}

// Function to filter reports based on a search query
function filterReports(query) {
  logger.info(`Filtering reports with query: "${query}"`);
  const items = document.querySelectorAll('#reportUl li');
  items.forEach((item) => {
    const text = item.textContent.toLowerCase();
    item.style.display = text.includes(query.toLowerCase()) ? '' : 'none';
  });
  logger.info('Reports filtered successfully.');
}

// Add an event listener to the search input for filtering reports
const searchInput = document.getElementById('searchInput');
searchInput.addEventListener('input', () => {
  const query = searchInput.value;
  logger.info(`Search input changed: "${query}"`);
  filterReports(query);
});

// Initial load of reports
logger.info('Initializing report fetch...');
refreshReports();
