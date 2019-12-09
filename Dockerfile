ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
        net-tools \
        nginx \
        supervisor \
  \
  && apk add --no-cache --virtual .build-dependencies \
        git \
        build-base \
        yarn \
  \
  && cd /etc \
  && git clone https://github.com/etesync/etesync-web.git \
  && cd etesync-web \
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
