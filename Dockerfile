FROM ubuntu:18.04

WORKDIR work
ADD conf/ conf
ADD install.sh install.sh

RUN ["chmod", "+x", "install.sh"]

RUN ["./install.sh"]
