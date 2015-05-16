#
# REQUIRES:
#       - server (the root server instance)
#

# Only Install PHP Extensions When Not On HHVM

# Install The Mongo Extension

printf "no\n" | pecl install mongo
echo "extension=mongo.so" > /etc/php5/mods-available/mongo.ini
ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/20-mongo.ini
ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/20-mongo.ini


curl -sL https://deb.nodesource.com/setup_0.12 | bash -

apt-get install -y nodejs

npm install -g pm2
npm install -g gulp