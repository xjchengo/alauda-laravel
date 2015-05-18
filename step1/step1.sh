#!/bin/bash

sed -i "s/exit.*/exit 0/" /usr/sbin/policy-rc.d

# Upgrade The Base Packages
cp /root/alauda/sources.list /etc/apt/sources.list
apt-get update
apt-get install -y wget

# Install ssh server

apt-get install -y openssh-server
mkdir /var/run/sshd
echo 'root:secret' | chpasswd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
echo "export VISIBLE=now" >> /etc/profile

# UTF-8 support

locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# Add A Few PPAs To Stay Current

apt-get install -y software-properties-common

apt-add-repository ppa:nginx/stable -y
apt-add-repository ppa:rwky/redis -y
apt-add-repository ppa:chris-lea/node.js -y
apt-add-repository ppa:ondrej/php5-5.6 -y

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
