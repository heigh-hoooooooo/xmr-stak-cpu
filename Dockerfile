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
    && cmake .. \
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

ENV USE_SLOW_MEMORY false
ENV NICEHASH_NONCE false
ENV AES_OVERRIDE null

ENV USE_TLS false
ENV TLS_SECURE_ALGO true
ENV TLS_FINGERPRINT ""

ENV CALL_TIMEOUT 10
ENV RETRY_TIME 10
ENV GIVEUP_LIMIT 0

ENV VERBOSE_LEVEL 4
ENV HASH_PRINT_TIME 10

ENV DAEMON_MODE false
ENV OUTPUT_FILE ""

ENV PREFER_IPV4 true
ENV HTTP_PORT 8080

ENV POOL_ADDRESS "fr01.supportxmr.com:5555"
ENV WALLET_ADDRESS "43esFA9Jpegb731vib2FSXELEB6ksoWcs9xp7BdD8hJAPyoeZ11jFkyPf2MXWvTTu54ftC87Kj257Tq9BqkFQp1RUPET3gA"
ENV WORKER_NAME "docker"
ENV EMAIL "heighhoooooooo@heighhoooooooo.fr"

COPY --from=builder /app/build/bin/xmr-stak-cpu /app/xmr-stak-cpu
RUN chmod +x /app/xmr-stak-cpu

COPY config.template /app/

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080
