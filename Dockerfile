FROM ubuntu:18.04

WORKDIR work
ADD conf/ conf
ADD script/ script
ADD install.sh install.sh

RUN ["chmod", "+x", "install.sh"]
RUN ["chmod", "+x", "script"]

RUN ["./install.sh"]
