FROM node:4.1.1-onbuild
MAINTAINER Selenium <selenium-developers@googlegroups.com>

ENV TEST_CMD ""
# The remainder of this build will be completed by the upstream image's ONBUILD commands


RUN apt-get update


RUN apt-get install -y openssh-server
RUN sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

RUN adduser --quiet jenkins

RUN echo "jenkins:jenkins" | chpasswd



RUN apt-get install -y openjdk-7-jdk
RUN apt-get install -y ant


ADD ./run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

CMD ["/bin/sh","/usr/bin/run.sh"]



