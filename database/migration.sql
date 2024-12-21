
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS metrics;

-- Use the database
USE metrics;

-- Table for system metrics
CREATE TABLE IF NOT EXISTS system_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME NOT NULL,
    cpu_usage FLOAT NOT NULL,
    cpu_temperature FLOAT DEFAULT NULL,
    memory_used VARCHAR(20) NOT NULL,
    memory_total VARCHAR(20) NOT NULL,
    disk_used VARCHAR(20) NOT NULL,
    disk_total VARCHAR(20) NOT NULL,
    gpu_usage FLOAT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for HTML reports
CREATE TABLE IF NOT EXISTS html_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(255) NOT NULL,
    report_content LONGTEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a sample record for testing purposes (optional)
INSERT INTO system_metrics (timestamp, cpu_usage, cpu_temperature, memory_used, memory_total, disk_used, disk_total, gpu_usage)
VALUES (NOW(), 15.5, 45.0, '8.2Gi', '16Gi', '200G', '500G', 35.0);

-- Insert another sample record for an HTML report (optional)
INSERT INTO html_reports (report_name, report_content, timestamp)
VALUES ('report_20241221_000000.html', '<html><body>Sample Report</body></html>', NOW());
