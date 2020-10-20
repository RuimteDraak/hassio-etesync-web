ARG BUILD_FROM
FROM $BUILD_FROM as builder
RUN apk add --no-cache \
        git \
        yarn
RUN mkdir /build
WORKDIR /build
RUN git clone https://github.com/etesync/etesync-web.git \
      && cd etesync-web \
      && git checkout 6ea3b880f93e1d0dda2896aa441cdd1efa227a25
WORKDIR /build/etesync-web
RUN yarn config set network-timeout 6000000 -g
RUN yarn
RUN yarn run --inspect build


FROM $BUILD_FROM

RUN apk add --no-cache \
        nginx \
        supervisor

COPY --from=builder /build/etesync-web/build /etc/server

COPY ./rootfs /

WORKDIR /etc/init
RUN chmod +x ./run.sh

CMD ./run.sh
