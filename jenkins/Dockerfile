FROM phusion/baseimage:0.9.15
MAINTAINER Mercer Traieste <mercer.traieste@gmail.com>

ENV HOME /root

CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y \
    curl \
    openjdk-7-jdk \
    ruby-full \
    vagrant
RUN apt-get install -y \
    libxslt-dev \
    libxml2-dev
RUN apt-get install -y \
    ruby-dev
RUN apt-get install -y \
    zlib1g-dev
RUN apt-get install -y \
    make
RUN apt-get install -y \
    build-essential
RUN gem install nokogiri -- --use-system-libraries=true --with-xml2-include=/usr/include/libxml2
RUN vagrant plugin install vagrant-aws

RUN curl -sSL https://get.docker.com/ | sh

ADD http://mirrors.jenkins-ci.org/war/1.590/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
CMD [""]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
