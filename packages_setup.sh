#!/bin/bash
echo "== Installing required software and development packages."
# Dropbox source
echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" | sudo tee "/etc/apt/sources.list.d/dropbox.list" > /dev/null
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E

sudo apt-get update

sudo apt-get -ym install git-core git-gui curl ack-grep vim \
gedit-plugins xclip synergy gitk \
libyaml-ruby libzlib-ruby libopenssl-ruby libmysql-ruby \
imagemagick libmagickwand-dev libmagickcore-dev libxslt1-dev libxml2-dev \
mysql-server postgresql sqlite3 libmysqlclient15-dev libpq-dev libsqlite3-dev \
apache2 python python-webkit python-webkit-dev python-pyinotify \
nautilus-dropbox nautilus-image-converter thunderbird libnotify-bin \
avant-window-navigator avant-window-navigator-data awn-settings \
awn-applets-c-core libawn1 vala-awn

