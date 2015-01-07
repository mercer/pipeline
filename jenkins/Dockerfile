FROM debian:wheezy
MAINTAINER Mercer Traieste <mercer.traieste@gmail.com>

RUN apt-get update && apt-get install -y \
    curl \
    openjdk-7-jdk \
    build-essential \
    libxslt-dev \
    libxml2-dev && \
    curl -sSL https://get.docker.com/ | sh && \
    curl -sOL https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.deb && \
    dpkg -i vagrant_1.6.5_x86_64.deb && \
    rm -f vagrant_1.6.5_x86_64.deb && \
    vagrant plugin install vagrant-aws && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -sOL http://mirrors.jenkins-ci.org/war/1.590/jenkins.war && \
    mv jenkins.war /opt/jenkins.war && \
    chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
CMD [""]
