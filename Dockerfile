################################################################################
###                                 BUILDER                                  ###
################################################################################
FROM alpine:edge as builder

WORKDIR /app

RUN apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
        libmicrohttpd-dev \
        hwloc-dev \
        openssl-dev \
        cmake \
        make \
        g++ \
    && rm -rf /var/cache/apk/*

COPY . .

RUN mkdir build \
    && cd build \
    && cmake -DHWLOC_ENABLE=OFF .. \
    && make -j$(nproc) \
    && cd ..

################################################################################
###                                PRODUCTION                                ###
################################################################################
FROM alpine:edge

RUN apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
        libmicrohttpd \
        hwloc \
        libstdc++ \
        libgcc \
        openssl \
        gettext \
    && rm -rf /var/cache/apk/*

ENV CONFIG /app/config.txt

ENV USE_SLOW_MEMORY warn
ENV NICEHASH_NONCE false
ENV AES_OVERRIDE true

ENV USE_TLS false
ENV TLS_SECURE_ALGO true
ENV TLS_FINGERPRINT ""

ENV CALL_TIMEOUT 10
ENV RETRY_TIME 10
ENV GIVEUP_LIMIT 0

ENV VERBOSE_LEVEL 4
ENV HASH_PRINT_TIME 30

ENV DAEMON_MODE false
ENV OUTPUT_FILE ""

ENV PREFER_IPV4 true
ENV HTTP_PORT 8080

ENV POOL_ADDRESS "pool.sumokoin.hashvault.pro:80"
ENV WALLET_ADDRESS "Sumoo4CE1iLj3MMTNFADCsPf3LYqgRH58NrCaXi1bch9b33Ap15Cx8E31pmuizHAvpdE1YPH3DuQHK9hMaxALGgAPCNA23CWXgA"
ENV WORKER_NAME "STAK_CPU_DOCKER"
ENV EMAIL "heighhoooooooo@heighhoooooooo.fr"

COPY --from=builder /app/build/bin/xmr-stak-cpu /app/xmr-stak-cpu
RUN chmod +x /app/xmr-stak-cpu

COPY docker/config.template /app/

COPY docker/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080
