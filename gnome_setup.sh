#!/bin/bash
echo "== Copying themes..."
mkdir -p ~/.themes
cp -rf assets/gtk_themes/* ~/.themes
echo "== Installing icons, fonts, compiz, etc..."
# PPAs
# --------------------------------------------------------------
# Faenza icons
sudo add-apt-repository ppa:tiheum/equinox
# Cortina (wallpaper switcher)
sudo add-apt-repository ppa:cs-sniffer/cortina
sudo apt-get update

sudo apt-get install -ym faenza-icon-theme \
compiz compizconfig-settings-manager cortina \
ttf-droid ttf-inconsolata

echo "== Configuring gnome font preferences..."
gconftool-2 --load assets/gnome_fonts_conf.xml

echo "===== Gnome preferences installed."

