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
  && git checkout 7fbac2c401741c429c25c90c815de26481b9a8d4 \
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
