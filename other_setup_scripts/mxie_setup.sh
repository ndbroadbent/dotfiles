#!/bin/bash
echo "== Setting up MXIE...  (NOTE: amd64 not supported.)"
echo "== Installing alien (installs rpm packages on debian-based systems)..."
sudo apt-get install -ym alien
cd /tmp
rm -f mxie*.deb

echo "== Parsing current MXIE package from mx250 index page..."
wget http://mx250/provisioning -O mxie_index.html
mxie_package=$(ruby -e 'puts File.open("mxie_index.html").read[/<a href="http:\/\/mx250:8000\/(mxie-.*\.rpm)/, 1]')
echo "==== Downloading..."
wget http://mx250:8000/$mxie_package -O $mxie_package
echo "==== Converting rpm => deb..."
sudo alien -k $mxie_package
echo "==== Installing..."
sudo dpkg -i mxie*.deb

