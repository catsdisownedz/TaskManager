const { createLogger, format, transports } = require('winston');

const logger = createLogger({
    level: 'info',
    format: format.combine(
        format.timestamp(),
        format.printf(({ timestamp, level, message }) => `${timestamp} [${level.toUpperCase()}]: ${message}`)
    ),
    transports: [
        new transports.Console(), // Log to console
        new transports.File({ filename: 'logs/system_monitor.log' }) // Log to file
    ]
});

module.exports = logger;
