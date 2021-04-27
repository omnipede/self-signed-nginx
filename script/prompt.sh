#!/bin/sh

# User input prompt
while true; do
  printf "[!] This action will not be rolled back. Continue? [y/N] "
  read -r yn

  case $yn in
    [Yy]* ) break;;
    [Nn]* ) echo "Exit."; exit;;
    * ) echo "Please answer yes or no.";;
  esac
done
