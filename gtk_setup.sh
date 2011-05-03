#!/bin/bash
echo "Copying themes..."
cp -rf assets/gtk_themes/* ~/.themes
echo "Installing icons..."
if ! (apt-cache search faenza-icon-theme | grep -q faenza); then
  sudo add-apt-repository ppa:tiheum/equinox
  sudo apt-get update
fi
sudo apt-get install faenza-icon-theme

echo "Configuring gtk fonts, etc..."
gconftool-2 --load assets/gtk_conf.xml

if [ -z `which gtk-theme-switch2` ]; then
  echo "== Install gtk-theme-switch with this command:"
  echo "        sudo apt-get install gtk-theme-switch"; echo
fi

echo "== Change themes with the following command:"
echo "        gtk-theme-switch2 ~/.themes/*******"

