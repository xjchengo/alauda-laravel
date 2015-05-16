#!/bin/bash
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
# sed -i '/^socket/s/socket.*=.*/socket = \/run\/mysqld\/mysqld.sock/' /etc/mysql/my.cnf
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO forge@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO forge@'%' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
service mysql restart

mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "CREATE USER 'forge'@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz';"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO 'forge'@'192.168.0.1' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz' WITH GRANT OPTION;"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "GRANT ALL ON *.* TO 'forge'@'%' IDENTIFIED BY 'gfAyWTAOpoULPvBZAilz' WITH GRANT OPTION;"
mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "FLUSH PRIVILEGES;"

# Create The Initial Database If Specified

mysql --user="root" --password="gfAyWTAOpoULPvBZAilz" -e "CREATE DATABASE forge;"
