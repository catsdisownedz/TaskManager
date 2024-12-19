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
    libc6-compat

WORKDIR /app

# If not using Python, comment these out:
# COPY ../python/requirements.txt /app/python/requirements.txt
# RUN pip3 install --no-cache-dir --upgrade pip && \
#     pip3 install --no-cache-dir -r /app/python/requirements.txt

# If you're not using Python at all, no need to COPY python directory:
# COPY ./python /app/python

COPY ./scripts /app/scripts
COPY ./dashboard /app/dashboard
COPY ./reports /app/reports
COPY ./web /app/web

RUN chmod -R +x /app

WORKDIR /app/web
RUN npm init -y && npm install express

ENTRYPOINT ["/app/entrypoint.sh"]
