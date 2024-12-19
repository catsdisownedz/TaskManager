FROM node:18-alpine

RUN apk update && apk add --no-cache \
    bash \
    coreutils \
    grep \
    sed \
    lm-sensors \
    util-linux \
    smartmontools \
    curl \
    zenity \
    libc6-compat \
    radeontop \
    intel-gpu-tools \
    python3 \
    py3-pip

RUN pip3 install gpustat

WORKDIR /app

COPY ./scripts /app/scripts
COPY ./dashboard /app/dashboard
COPY ./reports /app/reports
COPY ./web /app/web

RUN chmod -R +x /app

WORKDIR /app/web
RUN npm init -y && npm install express

ENTRYPOINT ["/app/entrypoint.sh"]
