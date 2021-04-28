FROM ubuntu:18.04

WORKDIR work
ADD conf/ conf
ADD script/ script
ADD start.sh start.sh

RUN ["chmod", "+x", "script"]

RUN ["sh", "./script/nginx.sh"]
RUN ["sh", "./script/ssl.sh"]
