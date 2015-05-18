FROM ubuntu:14.04
MAINTAINER xjchengo

COPY . /root/alauda
ENV DEBIAN_FRONTEND noninteractive

RUN chmod +x /root/alauda/all_in_one.sh
RUN /root/alauda/all_in_one.sh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
