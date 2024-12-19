FROM python:3.11-alpine

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
    libc6-compat

WORKDIR /app
COPY ../python/requirements.txt /app/python/requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r /app/python/requirements.txt

# Copy other files
COPY ./scripts /app/scripts
COPY ./dashboard /app/dashboard
COPY ./reports /app/reports
COPY ./python /app/python

RUN chmod -R +x /app
ENTRYPOINT ["/app/entrypoint.sh"]
