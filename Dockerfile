FROM ubuntu:16.04

RUN apt-get update -y
RUN apt-get upgrade -y 
RUN apt-get install git -y

RUN git config --global credential.helper "cache --timeout=3600"

COPY . /app
WORKDIR /app
RUN chmod 0777 script.sh