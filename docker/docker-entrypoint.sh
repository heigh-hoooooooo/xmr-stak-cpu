#!/bin/sh

WORKER_NAME=${HOSTNAME}

envsubst < /app/config.template > /app/config.txt
sed -i "s@STAK_CPU_DOCKER@$WORKER_NAME@" /app/config.txt

/app/xmr-stak-cpu ${CONFIG}
