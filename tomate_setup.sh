#!/bin/bash
PREFIX=/usr/local
INSTALLDIR="$PREFIX/share/tomate"
BINDIR="$PREFIX/bin"

if [ -z `which tomate` ]; then
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


  echo "==== Configuring Tomate to run on startup..."
  cat > ~/.config/autostart/tomate.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=tomate
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Tomate
Comment=Productivity Helper
EOF

  echo -e "\n== Installed! Tomate will run on system startup."
else
  echo "== Tomate already installed. If you want to reinstall, first run: $ sudo rm -f `which tomate`"
fi

