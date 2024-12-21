FROM node:18-slim

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    coreutils \
    grep \
    sed \
    lm-sensors \
    util-linux \
    smartmontools \
    curl \
    zenity \
    radeontop \
    intel-gpu-tools \
    python3 \
    python3-pip \
    python3-venv \
    dos2unix \
&& rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment for Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir gpustat

# Set working directory
WORKDIR /app

# Copy application files
COPY ./docker/entrypoint.sh /app/entrypoint.sh
COPY ./scripts /app/scripts
COPY ./dashboard /app/dashboard
COPY ./reports /app/reports
COPY ./web /app/web

# Convert line endings and set execute permissions
RUN dos2unix /app/entrypoint.sh /app/scripts/*.sh
RUN chmod +x /app/entrypoint.sh /app/scripts/*.sh
RUN find /app -type f -name "*.sh" -exec dos2unix {} \;
RUN chmod -R +x /app

# Set working directory for Node.js application
WORKDIR /app/web

# Copy package.json and package-lock.json
COPY ./web/package*.json ./

# Install Node.js dependencies
RUN npm init -y
RUN npm install express @influxdata/influxdb-client socket.io dotenv winston

# Install nodemon globally for development
RUN npm install -g nodemon

COPY . .
# Set working directory back to /app
WORKDIR /app

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
