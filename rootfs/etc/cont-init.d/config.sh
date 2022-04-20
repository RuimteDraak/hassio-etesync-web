#!/usr/bin/with-contenv bashio

bashio::log.info "Configure api path"
#Set default api
API_PATH=$(bashio::config 'api_path')
find /etc/server/static/js/ -type f -exec sed -i "s#@@DEFAULT_API_PATH@@#${API_PATH}#g" {} \;
