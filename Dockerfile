FROM ubuntu

RUN apt-get update && apt-get install figlet -y

RUN touch /tmp/hello