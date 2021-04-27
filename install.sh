#!/bin/sh

# This script is based on official nginx website:
#   http://nginx.org/en/linux_packages.html#Ubuntu

WORK_PATH=$(pwd)

# Update & install requirements
apt update
apt install curl gnupg2 ca-certificates lsb-release rpm -y

# Write nginx repository to apt file
echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

# Get nginx signing key
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
gpg --dry-run --quiet --import --import-options show-only /tmp/nginx_signing.key
mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc

# Important. Must update apt before install nginx
apt update
apt install nginx -y

# Install openssl via rpm
rpm -qa openssl

# Create ssl key & cert files
mkdir ssl
cd ssl || exit
openssl genrsa -des3 -out server.key -passout pass:FOOBAR 2048
openssl req -new -key server.key -out server.csr \
  -subj "/C=KR/ST=SEOUL/L=PANGYO/O=server/OU=dev/CN=server" \
  -passin pass:FOOBAR
cp server.key server.key.origin
openssl rsa -in server.key.origin -out server.key -passin pass:FOOBAR
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# NGINX ssl configuration
cd /etc/nginx || exit
mkdir ssl
cp "$WORK_PATH"/ssl/server.key ./ssl/server.key
cp "$WORK_PATH"/ssl/server.crt ./ssl/server.crt

mkdir snippets
cp "$WORK_PATH"/conf/self-signed.conf ./snippets/

openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096

cp "$WORK_PATH"/conf/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
chmod 644 /etc/nginx/snippets/ssl-params.conf

cp "$WORK_PATH"/conf/default.conf /etc/nginx/conf.d/default.conf

# Finish
cd "$WORK_PATH" || exit