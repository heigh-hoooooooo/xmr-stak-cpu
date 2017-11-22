#!/bin/sh

WORKER_NAME=${HOSTNAME}

envsubst < /app/config.template > /app/config.txt
/app/xmr-stak-cpu ${CONFIG}
