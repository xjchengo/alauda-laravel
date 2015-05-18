FROM ubuntu:14.04
MAINTAINER xjchengo

COPY . /root/alauda
ENV DEBIAN_FRONTEND noninteractive

RUN chmod +x /root/alauda/all_in_one.sh
RUN /root/alauda/all_in_one.sh

COPY supervisord.conf /etc/supervisor/conf.d

EXPOSE 22 80 3306
CMD ["supervisord"]
