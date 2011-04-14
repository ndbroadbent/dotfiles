# Requires 'alien', to install rpm packages on debian-based systems
sudo apt-get install -ym alien
cd /tmp
rm -f mxie*.deb

# Fetch mxie index page
wget http://mx250/provisioning -O mxie_index.html
# Parse out url of mxie rpm package.
mxie_package=$(ruby -e 'puts File.open("mxie_index.html").read[/<a href="http:\/\/mx250:8000\/(mxie-.*\.rpm)/, 1]')

wget http://mx250:8000/$mxie_package -O $mxie_package
sudo alien -k $mxie_package
sudo dpkg -i mxie*.deb
