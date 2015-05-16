#
# REQUIRES:
#       - server (the root server instance)
#       - site_name (the name of the site folder)
#       - sudo_password (random password for sudo)
#       - db_password (random password for database user)
#       - event_id (the provisioning event name)
#       - callback (the callback URL)
#

# Upgrade The Base Packages

cp /root/alauda/sources.list /etc/apt/sources.list
apt-get update

# install wget

apt-get install -y wget

# install ssh server

apt-get install -y openssh-server
mkdir /var/run/sshd
echo 'root:secret' | chpasswd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
echo "export VISIBLE=now" >> /etc/profile


# Add A Few PPAs To Stay Current

apt-get install -y software-properties-common

apt-add-repository ppa:nginx/stable -y
apt-add-repository ppa:rwky/redis -y
apt-add-repository ppa:chris-lea/node.js -y
# apt-add-repository ppa:ondrej/php5-5.6 -y

# Setup Postgres 9.4 Repositories

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'

# Update Package Lists

apt-get update
# Base Packages

apt-get install -y build-essential curl fail2ban gcc git libmcrypt4 libpcre3-dev \
make python-pip supervisor ufw unattended-upgrades unzip whois zsh

# Install Python Httpie

pip install httpie

# Set The Timezone

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Setup UFW Firewall

ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable

# Allow FPM Restart

echo "root ALL=NOPASSWD: /usr/sbin/service php5-fpm reload" > /etc/sudoers.d/php5-fpm
# Install Base PHP Packages

apt-get install -y php5-cli php5-dev php-pear \
php5-mysqlnd php5-pgsql php5-sqlite \
php5-apcu php5-json php5-curl php5-dev php5-gd \
php5-gmp php5-imap php5-mcrypt php5-memcached php5-xdebug

# Make The MCrypt Extension Available

ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
sudo php5enmod mcrypt
sudo service nginx restart

# Install Composer Package Manager

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Misc. PHP CLI Configuration

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/cli/php.ini


#
# REQUIRES:
#       - server (the root server instance)
#		- site_name (the name of the site folder)
#

# Install Nginx & PHP-FPM

apt-get install -y nginx php5-fpm

# Disable The Default Nginx Site

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
service nginx restart

# Tweak Some PHP-FPM Settings

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
sed -i "s/\;session.save_path = .*/session.save_path = \"\/var\/lib\/php5\/sessions\"/" /etc/php5/fpm/php.ini

# Configure Nginx & PHP-FPM To Run As root

sed -i "s/user www-data;/user root;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sed -i "s/^user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^group = www-data/group = root/" /etc/php5/fpm/pool.d/www.conf

sed -i "s/;listen\.owner.*/listen.owner = root/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/;listen\.group.*/listen.group = root/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php5/fpm/pool.d/www.conf

# Configure A Few More Server Things

sed -i "s/;request_terminate_timeout.*/request_terminate_timeout = 60/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/worker_processes.*/worker_processes auto;/" /etc/nginx/nginx.conf
sed -i "s/# multi_accept.*/multi_accept on;/" /etc/nginx/nginx.conf

# Install A Catch All Server

cat > /etc/nginx/sites-available/catch-all << EOF
server {
	return 404;
}
EOF

ln -s /etc/nginx/sites-available/catch-all /etc/nginx/sites-enabled/catch-all

# Restart Nginx & PHP-FPM Services

# Restart Nginx & PHP-FPM Services

service php5-fpm restart
service nginx restart

# Add Root User To www-data Group

usermod -a -G www-data root
id root
groups root

#
# REQUIRES:
#       - server (the root server instance)
#

# Only Install PHP Extensions When Not On HHVM


# Install The Phalcon Framework

# cd /root
# git clone --depth=1 https://github.com/phalcon/cphalcon.git
# cd /root/cphalcon/build
# ./install
# cd /root
# rm -rf /root/cphalcon
# echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini
# ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/fpm/conf.d/20-phalcon.ini
# ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/cli/conf.d/20-phalcon.ini

# Install The Mongo Extension

printf "no\n" | pecl install mongo
echo "extension=mongo.so" > /etc/php5/mods-available/mongo.ini
ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/20-mongo.ini
ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/20-mongo.ini


curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -

sudo apt-get install -y nodejs

npm install -g pm2
npm install -g gulp
#
# REQUIRES:
#		- server (the root server instance)
#		- db_password (random password for mysql user)
#

# Set The Automated Root Password

debconf-set-selections <<< "mysql-server mysql-server/root_password password gfAyWTAOpoULPvBZAilz"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password gfAyWTAOpoULPvBZAilz"

# Install MySQL

apt-get install -y mysql-server

# Configure Access Permissions For Root & Forge Users

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = */' /etc/mysql/my.cnf
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO root@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
service mysql restart

mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "CREATE USER 'root'@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO 'root'@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz' WITH GRANT OPTION;"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz' WITH GRANT OPTION;"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "FLUSH PRIVILEGES;"

# Create The Initial Database If Specified

mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "CREATE DATABASE forge;"

#
# REQUIRES:
#		- server (the forge server instance)
#		- db_password (random password for database user)
#

# Install Postgres

apt-get install -y postgresql-9.4

# Configure Postgres For Remote Access

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.4/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | tee -a /etc/postgresql/9.4/main/pg_hba.conf
sudo -u postgres psql -c "CREATE ROLE forge LOGIN UNENCRYPTED PASSWORD 'gfAyWTAOpoULPvBZAilz' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
service postgresql restart

# Create The Initial Database If Specified

sudo -u postgres /usr/bin/createdb --echo --owner=forge forge


# Install & Configure Redis Server

apt-get install -y redis-server
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
service redis-server restart
# Install & Configure Memcached

apt-get install -y memcached
sed -i 's/-l 127.0.0.1/-l 0.0.0.0/' /etc/memcached.conf
service memcached restart
# Install & Configure Beanstalk

apt-get install -y beanstalkd
sed -i "s/BEANSTALKD_LISTEN_ADDR.*/BEANSTALKD_LISTEN_ADDR=0.0.0.0/" /etc/default/beanstalkd
sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
/etc/init.d/beanstalkd start
