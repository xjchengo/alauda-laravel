#!/bin/bash

sed -i "s/exit.*/exit 0/" /usr/sbin/policy-rc.d

# Upgrade The Base Packages
cp /root/alauda/sources.list /etc/apt/sources.list
apt-get update
apt-get install -y wget

# # Install ssh server

# apt-get install -y openssh-server
# mkdir /var/run/sshd
# echo 'root:secret' | chpasswd
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# echo "export VISIBLE=now" >> /etc/profile

# UTF-8 support

locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# # Add A Few PPAs To Stay Current

# apt-get install -y software-properties-common

# check proxy
env | grep proxy

apt-add-repository ppa:nginx/stable -y
apt-add-repository ppa:rwky/redis -y
apt-add-repository ppa:chris-lea/node.js -y
apt-add-repository ppa:ondrej/php5-5.6 -y

# # Setup Postgres 9.4 Repositories

# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'

# # Update Package Lists

# apt-get update

# # Base Packages

# apt-get install -y build-essential curl gcc git libmcrypt4 libpcre3-dev \
# make python-pip supervisor unzip whois vim

# # Install Python Httpie

# pip install httpie

# # Set The Timezone

# ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


# # Install Base PHP Packages

# apt-get install -y php5-cli php5-dev php-pear \
# php5-mysqlnd php5-pgsql php5-sqlite \
# php5-apcu php5-json php5-curl php5-dev php5-gd \
# php5-gmp php5-imap php5-mcrypt php5-memcached php5-xdebug

# # Make The MCrypt Extension Available

# php5enmod mcrypt

# # Install Composer Package Manager

# curl -sS https://getcomposer.org/installer | php
# mv composer.phar /usr/local/bin/composer

# # Misc. PHP CLI Configuration

# sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
# sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
# sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/cli/php.ini
# sed -i "s/;date.timezone.*/date.timezone = Asia/Shanghai/" /etc/php5/cli/php.ini

# # Setup Alauda User

# useradd alauda
# mkdir -p /home/alauda/.ssh
# mkdir -p /home/alauda/.alauda
# adduser alauda sudo

# # Setup Bash For alauda User

# chsh -s /bin/bash alauda
# cp /root/.profile /home/alauda/.profile
# cp /root/.bashrc /home/alauda/.bashrc

# # Set The Sudo Password For alauda

# PASSWORD=$(mkpasswd alauda)
# usermod --password $PASSWORD alauda

# # Setup Site Directory Permissions

# chown -R alauda:alauda /home/alauda
# chmod -R 755 /home/alauda

# # Install Nginx & PHP-FPM

# apt-get install -y nginx php5-fpm

# # Disable The Default Nginx Site

# rm /etc/nginx/sites-enabled/default
# rm /etc/nginx/sites-available/default
# service nginx restart

# # Tweak Some PHP-FPM Settings

# sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
# sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini
# sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
# sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/fpm/php.ini
# sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
# sed -i "s/\;session.save_path = .*/session.save_path = \"\/var\/lib\/php5\/sessions\"/" /etc/php5/fpm/php.ini

# # Configure Nginx & PHP-FPM To Run As alauda

# sed -i "s/user www-data;/user alauda;/" /etc/nginx/nginx.conf
# sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

# sed -i "s/^user = www-data/user = alauda/" /etc/php5/fpm/pool.d/www.conf
# sed -i "s/^group = www-data/group = alauda/" /etc/php5/fpm/pool.d/www.conf

# sed -i "s/;listen\.owner.*/listen.owner = alauda/" /etc/php5/fpm/pool.d/www.conf
# sed -i "s/;listen\.group.*/listen.group = alauda/" /etc/php5/fpm/pool.d/www.conf
# sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php5/fpm/pool.d/www.conf

# # Configure A Few More Server Things

# sed -i "s/;request_terminate_timeout.*/request_terminate_timeout = 60/" /etc/php5/fpm/pool.d/www.conf
# sed -i "s/worker_processes.*/worker_processes auto;/" /etc/nginx/nginx.conf
# sed -i "s/# multi_accept.*/multi_accept on;/" /etc/nginx/nginx.conf

# # Install A Catch All Server

# cat > /etc/nginx/sites-available/catch-all << EOF
# server {
# 	return 404;
# }
# EOF

# ln -s /etc/nginx/sites-available/catch-all /etc/nginx/sites-enabled/catch-all

# # Restart Nginx & PHP-FPM Services

# service php5-fpm restart
# service nginx restart

# # Add alauda User To www-data Group

# usermod -a -G www-data alauda
# id alauda
# groups alauda

# #!/bin/bash
# # Install The Mongo Extension

# printf "no\n" | pecl install mongo
# echo "extension=mongo.so" > /etc/php5/mods-available/mongo.ini
# ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/20-mongo.ini
# ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/20-mongo.ini


# curl -sL https://deb.nodesource.com/setup_0.12 | bash -

# apt-get install -y nodejs

# echo 'npm install start'
# npm config set registry https://registry.npm.taobao.org 
# npm install -g pm2
# npm install -g gulp

# # Set The Automated Root Password

# debconf-set-selections <<< "mysql-server mysql-server/root_password password secret"
# debconf-set-selections <<< "mysql-server mysql-server/root_password_again password secret"

# # Install MySQL

# apt-get install -y mysql-server

# # Configure Access Permissions For Root & alauda Users

# sed -i '/^bind-address/s/bind-address.*=.*/bind-address = */' /etc/mysql/my.cnf
# # sed -i '/^socket/s/socket.*=.*/socket = \/run\/mysqld\/mysqld.sock/' /etc/mysql/my.cnf
# mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO alauda@'192.168.0.1' IDENTIFIED BY 'secret';"
# mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO alauda@'%' IDENTIFIED BY 'secret';"
# service mysql restart

# mysql --user="root" --password="secret" -e "CREATE USER 'alauda'@'192.168.0.1' IDENTIFIED BY 'secret';"
# mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'alauda'@'192.168.0.1' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
# mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'alauda'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
# mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"

# # Create The Initial Database If Specified

# mysql --user="root" --password="secret" -e "CREATE DATABASE alauda;"

# # Install Postgres

# apt-get install -y postgresql-9.4

# # Configure Postgres For Remote Access

# sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.4/main/postgresql.conf
# echo "host    all             all             0.0.0.0/0               md5" | tee -a /etc/postgresql/9.4/main/pg_hba.conf
# sudo -u postgres psql -c "CREATE ROLE alauda LOGIN UNENCRYPTED PASSWORD 'secret' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
# service postgresql restart

# # Create The Initial Database If Specified

# sudo -u postgres /usr/bin/createdb --echo --owner=alauda alauda
