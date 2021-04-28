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

# Prompt
sh "$SCRIPT_DIR"/prompt.sh

## Install nginx
sh "$SCRIPT_DIR"/nginx.sh

# Configure nginx's SSL feature.
sh "$SCRIPT_DIR"/ssl.sh
