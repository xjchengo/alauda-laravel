#!/bin/bash
# Install The Mongo Extension

printf "no\n" | pecl install mongo
echo "extension=mongo.so" > /etc/php5/mods-available/mongo.ini
ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/20-mongo.ini
ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/20-mongo.ini


curl -sL https://deb.nodesource.com/setup_0.12 | bash -

apt-get install -y nodejs

echo 'npm install start'
npm config set registry https://registry.npm.taobao.org 
npm install -g pm2
npm install -g gulp

# Set The Automated Root Password

debconf-set-selections <<< "mysql-server mysql-server/root_password password gfAyWTAOpoULPvBZAilz"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password gfAyWTAOpoULPvBZAilz"

# Install MySQL

apt-get install -y mysql-server

# Configure Access Permissions For Root & xjchen Users

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = */' /etc/mysql/my.cnf
# sed -i '/^socket/s/socket.*=.*/socket = \/run\/mysqld\/mysqld.sock/' /etc/mysql/my.cnf
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO xjchen@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO xjchen@'%' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
service mysql restart

mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "CREATE USER 'xjchen'@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO 'xjchen'@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz' WITH GRANT OPTION;"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO 'xjchen'@'%' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz' WITH GRANT OPTION;"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "FLUSH PRIVILEGES;"

# Create The Initial Database If Specified

mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "CREATE DATABASE xjchen;"

# Install Postgres

apt-get install -y postgresql-9.4

# Configure Postgres For Remote Access

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.4/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | tee -a /etc/postgresql/9.4/main/pg_hba.conf
sudo -u postgres psql -c "CREATE ROLE xjchen LOGIN UNENCRYPTED PASSWORD 'gfAyWTAOpoULPvBZAilz' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
service postgresql restart

# Create The Initial Database If Specified

sudo -u postgres /usr/bin/createdb --echo --owner=xjchen xjchen
