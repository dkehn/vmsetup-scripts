#!/bin/bash

UPD_CMD=‘apt-get’

echo “installing packages......”
sudo $UPD_CMD install ssh git htop emacs vim build-essential zliblg-dev libzip-dev libxml2 libpq-dev libxslt1-dev openssl libssl-dev python3-pip tree tox libsqlite3-dev -y

# build the python 3.6

if [ -z `which python3.6` ]; then
   cd /opt
   sudo wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz
   sudo tar -zxvf Python-3.6.4.tgz
   cd Python-3.6.4
   sudo ./configure
   sudo make
   sudo make install
   python3.6 -V
fi

echo "Completed in $SECONDS seconds."