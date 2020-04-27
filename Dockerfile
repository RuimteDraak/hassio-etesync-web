ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
        nginx \
        supervisor \
  \
  && apk add --no-cache --virtual .build-dependencies \
        git \
        yarn \
  \
  && cd /etc \
  && git clone https://github.com/etesync/etesync-web.git \
  && cd etesync-web \
  && git checkout 04c4ae94cd28987ec05ec5c6faea695184c0e7d1 \
  && yarn config set network-timeout 600000 -g \
  && yarn \
  && yarn build \
  && cd .. \
  && mv etesync-web/build server \
  && cd server \
  && chown -R root:www-data ./ \
  && chmod -R 754 ./ \
  && apk del --purge .build-dependencies \
  && rm -rf /etc/etesync-web/

COPY ./rootfs /

WORKDIR /etc/init
RUN chmod +x ./run.sh

CMD ./run.sh
