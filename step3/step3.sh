# Setup Forge User

useradd xjchen
mkdir -p /home/xjchen/.ssh
mkdir -p /home/xjchen/.xjchen
adduser xjchen sudo

# Setup Bash For xjchen User

chsh -s /bin/bash xjchen
cp /root/.profile /home/xjchen/.profile
cp /root/.bashrc /home/xjchen/.bashrc

# Set The Sudo Password For xjchen

PASSWORD=$(mkpasswd 1O6XidSsB4Frr2OvPoK7)
usermod --password $PASSWORD xjchen

# Setup Site Directory Permissions

chown -R xjchen:xjchen /home/xjchen
chmod -R 755 /home/xjchen

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

sed -i "s/user www-data;/user xjchen;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sed -i "s/^user = www-data/user = xjchen/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^group = www-data/group = xjchen/" /etc/php5/fpm/pool.d/www.conf

sed -i "s/;listen\.owner.*/listen.owner = xjchen/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/;listen\.group.*/listen.group = xjchen/" /etc/php5/fpm/pool.d/www.conf
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

service php5-fpm restart
service nginx restart

# Add xjchen User To www-data Group

usermod -a -G www-data xjchen
id xjchen
groups xjchen
