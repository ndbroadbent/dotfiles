#!/bin/bash
PREFIX=/usr/local
INSTALLDIR="$PREFIX/share/tomate"
BINDIR="$PREFIX/bin"

echo "== Installing Tomate..."

# Clean up old installation
sudo rm -rf $INSTALLDIR/
sudo rm -f "$BINDIR/tomate"
rm -rf /tmp/tomate

git clone https://git.gitorious.org/tomate/tomate.git /tmp/tomate
cd /tmp/tomate
sed -i "s/env python2/env python/g" tomate.py

# Run install script
sudo ./install.sh

echo -e "\n== Installed! Now add 'tomate' to your startup applications."

