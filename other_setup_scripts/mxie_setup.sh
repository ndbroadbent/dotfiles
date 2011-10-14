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
echo "==== Symlinking and installing older required libraries..."
sudo ln -fs /usr/lib/libssl.so.0.9.8 /usr/lib/libssl.so.0.9.7
sudo ln -fs /usr/lib/libcrypto.so.0.9.8 /usr/lib/libcrypto.so.0.9.7
wget http://ftp.us.debian.org/debian/pool/main/g/gcc-3.3/libstdc++5_3.3.6-18_i386.deb -O /tmp/libstdc++5.deb
sudo dpkg -i /tmp/libstdc++5.deb

# Start MXIE on system startup
cat > ~/.config/autostart/mxie.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=/usr/local/bin/mxie
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=MXIE
Comment=
EOF

