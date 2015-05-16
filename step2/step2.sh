
# Install Base PHP Packages

apt-get install -y php5-cli php5-dev php-pear \
php5-mysqlnd php5-pgsql php5-sqlite \
php5-apcu php5-json php5-curl php5-dev php5-gd \
php5-gmp php5-imap php5-mcrypt php5-memcached php5-xdebug

# Make The MCrypt Extension Available

php5enmod mcrypt

# Install Composer Package Manager

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Misc. PHP CLI Configuration

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/cli/php.ini

