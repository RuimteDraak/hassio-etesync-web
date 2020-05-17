ARG BUILD_FROM
FROM $BUILD_FROM as builder
RUN apk add --no-cache \
        git \
        yarn
RUN mkdir /build
WORKDIR /build
RUN git clone https://github.com/etesync/etesync-web.git \
      && cd etesync-web \
      && git checkout 04c4ae94cd28987ec05ec5c6faea695184c0e7d1
WORKDIR /build/etesync-web
RUN yarn config set network-timeout 600000 -g
RUN yarn
RUN yarn build


FROM $BUILD_FROM

RUN apk add --no-cache \
        nginx \
        supervisor

COPY --from=builder /build/etesync-web/build /etc/server

COPY ./rootfs /

WORKDIR /etc/init
RUN chmod +x ./run.sh

CMD ./run.sh
