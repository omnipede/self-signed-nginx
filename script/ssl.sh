#!/bin/sh

# This script configure nginx SSL features.

# Absolute path this script is in, thus /home/user/bin
CURRENT_DIR=$(pwd)
BASEDIR=$(dirname "$0")
if [ "$BASEDIR" = '.' ]
then
  BASEDIR="$CURRENT_DIR"
fi

PARENT_DIR=$(dirname "$BASEDIR")

if [ "$PARENT_DIR" = '.' ]
then
  PARENT_DIR="$CURRENT_DIR"
fi

# Path of nginx configuration directory
CONF_DIR="$PARENT_DIR"/conf
# Path of SSL secret files
SSL_DIR="$PARENT_DIR"/ssl

# Install openssl via rpm
rpm -qa openssl

# Create ssl key & cert files
mkdir "$SSL_DIR"
cd "$SSL_DIR" || exit
openssl genrsa -des3 -out server.key -passout pass:"$2" 2048
openssl req -new -key server.key -out server.csr \
  -subj "$1" \
  -passin pass:"$2"
cp server.key server.key.origin
openssl rsa -in server.key.origin -out server.key -passin pass:"$2"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

cd - || exit

# NGINX ssl configuration
mkdir /etc/nginx/ssl
cp "$SSL_DIR"/server.key /etc/nginx/ssl/server.key
cp "$SSL_DIR"/server.crt /etc/nginx/ssl/server.crt

mkdir /etc/nginx/snippets
cp "$CONF_DIR"/self-signed.conf /etc/nginx/snippets/

openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096

cp "$CONF_DIR"/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
chmod 644 /etc/nginx/snippets/ssl-params.conf

cp "$CONF_DIR"/default.conf /etc/nginx/conf.d/default.conf