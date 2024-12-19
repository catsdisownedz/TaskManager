//da el server el e7na hn2aweb 3aleh el web

const express = require('express');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const app = express();

// hana5od el web static files mn el directory di ayoyoo
app.use(express.static('web'));
app.use(express.json());

// api Endpoint to fetch metrics, which we will post on the json 3shan na5odha men hena
// ana b2a el mfrod yb2a 3ndy script ye7awel el metrics le json so before i run this, i need to test out if the json output is amazing or no
app.get('/metrics', (req, res) => {
  // For now, imagine metrics.json holds CPU, memory, etc.
  //i will generate metrics.json by running it periodically as a background process oki? we b3den hn7awelo le json that server.jscan read
  fs.readFile(path.join(__dirname, 'metrics.json'), 'utf8', (err, data) => {
    if (err) {
      return res.json({ error: 'No metrics available' });
    }
    res.header("Content-Type","application/json");
    res.send(data);
  });
});


//generates a new html report bl bash and sends it to the front end script 
app.post('/generate_report', (req, res) => {
    exec('/app/scripts/generate_html_report.sh', (error) => {
      if (error) {
        console.error(error);
        return res.status(500).json({error: 'Failed to generate report'});
      }
      res.json({message: 'Report generated successfully'});
    });
  });
  
  //el endpoint di returns a json array of el available reports sorted men new to old 
  app.get('/reports', (req, res) => {
    const reportsDir = path.join(__dirname, '../reports/html');
    //hy5osh el folder reports/html we uyshoof el files el m7toota henak 
    fs.readdir(reportsDir, (err, files) => {
      if (err) {
        return res.json([]);
      }
      const htmlReports = files.filter(f => f.endsWith('.html'));
      //extract timestamp from filename: report_YYYYMMDD_HHMMSS.html
      const reportsWithTime = htmlReports.map(filename => {
        const match = filename.match(/report_(\d{8})_(\d{6})\.html/);
        if (match) {
          const datePart = match[1];
          const timePart = match[2];
          const year = datePart.slice(0,4);
          const month = datePart.slice(4,6);
          const day = datePart.slice(6,8);
          const hour = timePart.slice(0,2);
          const min = timePart.slice(2,4);
          const sec = timePart.slice(4,6);
          const dateObj = new Date(`${year}-${month}-${day}T${hour}:${min}:${sec}Z`);
          return {filename, time: dateObj.toISOString()};
        } else {
          return {filename, time: ''}
        }
      });
      
      //sorted by time 
      reportsWithTime.sort((a,b) => new Date(b.time) - new Date(a.time));
      res.json(reportsWithTime);
    });
  });
  
  // da for the individual selected report
  app.get('/reports/:filename', (req, res) => {
    const reportsDir = path.join(__dirname, '../reports/html');
    const filePath = path.join(reportsDir, req.params.filename);
    fs.exists(filePath, (exists) => {
      if (!exists) return res.status(404).send('Report not found');
      res.sendFile(filePath);
    });
  });
  



const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  //this is the port where the website will run yaya
});
