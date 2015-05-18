FROM ubuntu:14.04
MAINTAINER xjchengo

COPY . /root/alauda
ENV DEBIAN_FRONTEND noninteractive

RUN /root/alauda/step1.sh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
