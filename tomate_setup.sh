#!/bin/bash
PREFIX=/usr/local
INSTALLDIR="$PREFIX/share/tomate"
BINDIR="$PREFIX/bin"

# Install Tomate (productivity script)
# -------------------------------------------
echo "== Installing tomate..."

rm -rf /tmp/tomate
git clone https://git.gitorious.org/tomate/tomate.git /tmp/tomate
cd /tmp/tomate
sed -i "s/env python2/env python/g" tomate.py

sudo rm -rf $INSTALLDIR/
sudo rm -f "$BINDIR/tomate"
sudo mkdir -p "$INSTALLDIR"
sudo cp -f *.{png,svg,py} "$INSTALLDIR/"
sudo cp -f "$INSTALLDIR/tomate.py" "$BINDIR/tomate"

tomate &

