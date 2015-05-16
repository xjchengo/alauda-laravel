FROM step8
MAINTAINER xjchengo

COPY . /root/alauda
ENV DEBIAN_FRONTEND noninteractive

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
