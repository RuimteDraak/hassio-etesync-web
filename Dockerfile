ARG BUILD_FROM
FROM $BUILD_FROM as builder
RUN apk add --no-cache \
        git \
        build-base \
        linux-headers \
        yarn \
    && mkdir /build \
    && cd build \
    && git clone https://github.com/etesync/etesync-web.git --single-branch \
    && cd etesync-web \
    && yarn config set network-timeout 6000000 -g


WORKDIR /build/etesync-web
RUN yarn && yarn run --inspect build

FROM $BUILD_FROM

RUN apk add --no-cache nginx

COPY --from=builder /build/etesync-web/build /etc/server
COPY ./rootfs /