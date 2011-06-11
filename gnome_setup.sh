#!/bin/bash
. _shared.sh
# Install Gnome preferences
# -------------------------------------------
echo "== Setting up gnome preferences..."

echo "==== Copying themes..."
mkdir -p ~/.themes
cp -rf assets/gtk_themes/* ~/.themes

echo "==== Installing icons, fonts, software..."

# PPAs
# --------------------------------------------------------------
# Faenza icons
if ! (apt-cache search faenza-icon-theme | grep -q faenza-icon-theme); then
  sudo add-apt-repository ppa:tiheum/equinox
fi
# Cortina (wallpaper switcher)
if ! (apt-cache search cortina | grep -q cortina); then
  sudo add-apt-repository ppa:cs-sniffer/cortina
fi

# Queue or install apt packages
apt_queue_or_install "faenza-icon-theme
compiz compizconfig-settings-manager cortina
ttf-droid ttf-inconsolata"

echo "==== Configuring font preferences..."
gconftool-2 --load assets/gnome_fonts_conf.xml

echo "==== Configuring cortina to run on startup..."
# Run Cortina on startup
cat > ~/.config/autostart/cortina.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=/usr/bin/cortina
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Cortina
Comment=Rotates wallpaper periodically
EOF

