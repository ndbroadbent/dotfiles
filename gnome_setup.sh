#!/bin/bash
echo "== Copying themes..."
cp -rf assets/gtk_themes/* ~/.themes
echo "== Installing icons..."
if ! (apt-cache search faenza-icon-theme | grep -q faenza); then
  sudo add-apt-repository ppa:tiheum/equinox
  sudo apt-get update
fi
sudo apt-get install faenza-icon-theme

echo "== Configuring gnome font preferences..."
gconftool-2 --load assets/gnome_fonts_conf.xml

echo "===== GTK preferences installed."

