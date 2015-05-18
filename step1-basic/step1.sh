#!/bin/bash

sed -i "s/exit.*/exit 0/" /usr/sbin/policy-rc.d

# Upgrade The Base Packages
cp /root/alauda/sources.list /etc/apt/sources.list
apt-get update
apt-get install -y wget

# UTF-8 support

locale-gen en_US.UTF-8
echo "export LANG=en_US.UTF-8" >> /etc/profile

# Add A Few PPAs To Stay Current

apt-get install -y software-properties-common

# trying to install PPA behind firewall fails:
# apt-add-repository ppa:nginx/stable -y
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C
apt-key add /root/alauda/nginx.key
# apt-add-repository ppa:rwky/redis -y
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5862E31D
apt-key add /root/alauda/redis.key
# apt-add-repository ppa:chris-lea/node.js -y
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C7917B12
apt-key add /root/alauda/nodejs.key
# apt-add-repository ppa:ondrej/php5-5.6 -y
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C
apt-key add /root/alauda/php.key

# Setup Postgres 9.4 Repositories

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'

# Update Package Lists

apt-get update

# Base Packages

apt-get install -y build-essential curl gcc git libmcrypt4 libpcre3-dev \
make python-pip supervisor unzip whois vim

# Install Python Httpie

pip install httpie

# Set The Timezone

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
