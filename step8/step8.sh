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
