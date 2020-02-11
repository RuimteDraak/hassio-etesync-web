ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
        nginx=1.16.1-r7 \
        supervisor=4.1.0-r1 \
  \
  && apk add --no-cache --virtual .build-dependencies \
        git=2.25.0-r0 \
        yarn=1.22.0-r0 \
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
