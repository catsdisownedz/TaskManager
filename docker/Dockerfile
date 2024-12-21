FROM node:18-slim

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

WORKDIR /app

COPY ./docker/entrypoint.sh /app/entrypoint.sh
COPY ./scripts /app/scripts
COPY ./dashboard /app/dashboard
COPY ./reports /app/reports
COPY ./web /app/web

RUN find /app -type f -name "*.sh" -exec dos2unix {} \;
RUN chmod -R +x /app

WORKDIR /app/web
RUN npm init -y && npm install express
RUN npm install -g nodemon

WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
