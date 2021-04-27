#!/bin/sh

# This script is based on official nginx website:
#   http://nginx.org/en/linux_packages.html#Ubuntu

# Absolute path this script is in, thus /home/user/bin
CURRENT_DIR=$(pwd)
BASEDIR=$(dirname "$0")

if [ "$BASEDIR" = '.' ]
then
  BASEDIR="$CURRENT_DIR"
fi

# Directory where other shell scripts reside
SCRIPT_DIR="$BASEDIR"/script

# Install nginx
sh "$SCRIPT_DIR"/nginx.sh

# Configure nginx's SSL feature.
sh "$SCRIPT_DIR"/ssl.sh
