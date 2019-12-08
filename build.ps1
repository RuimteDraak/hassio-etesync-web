docker build --build-arg BUILD_FROM="homeassistant/amd64-base:latest" -t local/hassio-etesync-web .

# run: 
# create a data folder with options.json and update the volume path
# docker run --rm -it -v E:/Lars/Development/hassio/hassio-etesync-web/data:/data -p 80:8080 local/hassio-etesync-web