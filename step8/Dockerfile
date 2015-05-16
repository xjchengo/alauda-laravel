FROM step7
MAINTAINER xjchengo

COPY . /root/alauda
ENV DEBIAN_FRONTEND noninteractive

RUN /root/alauda/step8.sh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
