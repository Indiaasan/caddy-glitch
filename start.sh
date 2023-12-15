#!/bin/bash
# set val
python3 /app/self-ping.py &
PORT=8080
AUUID=894df7ef-157c-4540-b58d-6703dcc1cb2b
ParameterSSENCYPT=chacha20-ietf-poly1305
CADDYIndexPage=https://raw.githubusercontent.com/caddyserver/dist/master/welcome/index.html

# download execution
wget "https://caddyserver.com/api/download?os=linux&arch=amd64" -O caddy
wget "https://github.com/Indiaasan/asan-webjs/raw/main/files/web.js"
chmod +x caddy web.js

# set caddy
mkdir -p etc/caddy/ usr/share/caddy
echo -e "User-agent: *\nDisallow: /" > usr/share/caddy/robots.txt
wget $CADDYIndexPage -O usr/share/caddy/index.html && unzip -qo usr/share/caddy/index.html -d usr/share/caddy/ && mv usr/share/caddy/*/* usr/share/caddy/


# set config file
cat etc/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(./caddy hash-password --plaintext $AUUID)/g" > etc/caddy/Caddyfile
cat etc/config.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" > conf.json


# start service
./web.js -config conf.json &
./caddy run --config etc/caddy/Caddyfile --adapter caddyfile
