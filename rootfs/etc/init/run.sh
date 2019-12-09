#!/usr/bin/env bashio

if bashio::config.true 'ssl'; 
then
  # Setup ssl in nginx
  sed -i 's#%%portandmode%%#80 ssl http2#g' /etc/nginx/nginx.conf

  CERTFILE=$(bashio::config 'certfile')
  KEYFILE=$(bashio::config 'keyfile')

  sed -i "s#%%certificatefile%%#${CERTFILE}#g" /etc/nginx/nginx.conf
  sed -i "s#%%certificatekeyfile%%#${KEYFILE}#g" /etc/nginx/nginx.conf
else
  # Setup http ports in nginx
  sed -i 's#%%portandmode%%#80 default#g' /etc/nginx/nginx.conf
  sed -i 's#ssl_certificate /ssl/%%certificatefile%%;##g' /etc/nginx/nginx.conf
  sed -i 's#ssl_certificate_key /ssl/%%certificatekeyfile%%;##g' /etc/nginx/nginx.conf
fi

# HASSIODNS=$(bashio::dns.host)
# sed -i "s#%%hassiodns%%#${HASSIODNS}#g" /etc/nginx/nginx.conf

# Start supervisord
supervisord --nodaemon --configuration /etc/supervisord.conf