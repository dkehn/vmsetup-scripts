#!/bin/bash

UPD_CMD="/usr/bin/apt-get"

echo “installing packages......”
sudo $UPD_CMD install ssh git htop emacs vim build-essential libzip-dev libxml2 libpq-dev libxslt1-dev openssl libssl-dev libmysqlclient-dev p\
ython3-pip tree mysql-server-5.7 tox libsqlite3-dev -y

# once you get back
if [ -f /etc/init.d/mysql ]; then
   sudo /etc/init.d/mysql restart
else
   sudo service mysqld restart
fi

sudo mysql -u root -p -e 'create database IF NOT EXISTS icp;'
sudo mysql -u root -p -e 'grant all privileges on icp.* to icp@"localhost" identified by "icp";'
sudo mysql -u root -p -e 'flush privileges;'

echo "Completed in $SECONDS seconds."