#!/bin/sh

# Absolute path this script is in, thus /home/user/bin
CURRENT_DIR=$(pwd)
BASEDIR=$(dirname "$0")

if [ "$BASEDIR" = '.' ]
then
  BASEDIR="$CURRENT_DIR"
fi

# Directory where other shell scripts reside
SCRIPT_DIR="$BASEDIR"/script

while getopts "y" opt; do
  case $opt in
    y)
        yn="y"
        ;;
    *)
        exit
        ;;
  esac
done

# User input prompt
while true; do
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) echo "Exit."; exit 1;;
    * ) echo "Please answer yes or no.";;
  esac

  printf "[!] This action will not be rolled back. Continue? [y/N] "
  read -r yn
done

# Import configuration
. "$BASEDIR"/start.conf

# Install nginx
sh "$SCRIPT_DIR"/nginx.sh

# Configure nginx's SSL feature.
sh "$SCRIPT_DIR"/ssl.sh \
  "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG/OU=$ORG_UNIT/CN=$COMMON_NAME" \
  "$SSL_PASSWORD"
