#!/usr/bin/env bash
# collect_network.sh
# Collects network RX/TX bytes.

source ./logging.sh

# IFACE="eth0"
# RX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
# TX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

# log_metric "NET_RX_BYTES" "$RX_BYTES"
# log_metric "NET_TX_BYTES" "$TX_BYTES"

# curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "net_rx_bytes value=$RX_BYTES" > /dev/null
# curl -s -XPOST 'http://influxdb:8086/write?db=metrics' --data-binary "net_tx_bytes value=$TX_BYTES" > /dev/null
