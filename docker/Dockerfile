FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg \
        ca-certificates \
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
        python3 \
        python3-pip \
        python3-venv \
        dos2unix \
        jq \
        build-essential \
        libssl-dev \
        libc6 \
        libc6-dev \
        libgcc-9-dev \
        libstdc++-9-dev \
        libffi-dev \
        zlib1g \
        zlib1g-dev \
        xz-utils \
        git \
        wget \
        libegl1 \
        libgl1 \
        dbus-x11 \
        x11-apps && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js installation
RUN node -v && npm -v

# Create and activate a virtual environment for Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir gpustat

# Set working directory
WORKDIR /app

# Copy application files
COPY ./docker/entrypoint.sh /app/entrypoint.sh
COPY ./scripts /app/scripts
COPY ./reports /app/reports
COPY ./web /app/web

# Convert line endings and set execute permissions
RUN find /app -type f -name "*.sh" -exec dos2unix {} + && chmod +x /app/entrypoint.sh /app/scripts/*.sh

# Set working directory for Node.js application
WORKDIR /app/web
COPY ./web/package*.json ./

# Install Node.js dependencies
RUN npm install express @influxdata/influxdb-client socket.io dotenv winston

# Install nodemon globally for development
RUN npm install -g nodemon

# Set working directory back to /app
WORKDIR /app

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
