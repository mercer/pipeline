FROM stackbrew/ubuntu:14.10
MAINTAINER Mercer Traieste <mercer.traieste@gmail.com>

RUN apt-get update && apt-get clean
RUN apt-get install -q -y openjdk-7-jre-headless && apt-get clean
RUN apt-get install -q -y curl && apt-get clean

RUN curl -sSL https://get.docker.com/ | sh

ADD http://mirrors.jenkins-ci.org/war/1.590/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
CMD [""]

#RUN sudo usermod -aG docker your-user
#RUN gpasswd -a jenkins docker
#USER jenkins