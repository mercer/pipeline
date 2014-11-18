FROM jenkins:weekly
MAINTAINER Mercer Traieste <mercer.traieste@gmail.com>
USER root
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install apache2 -y
RUN apt-get install php5-json -y
RUN git clone https://github.com/afaqurk/linux-dash.git /var/www/linux-dash
EXPOSE 80
RUN curl -sSL https://get.docker.com/ubuntu/ | sh
ENV DOCKER_HOST tcp://dockerhost:2375
USER jenkins