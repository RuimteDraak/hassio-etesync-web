docker build --build-arg BUILD_FROM="homeassistant/amd64-base:latest" -t local/hassio-etesync-web .

# run: 
# create a data folder with options.json and update the volume path
# docker run --rm -it -v ./data:/data -p 80:80 local/hassio-etesync-web