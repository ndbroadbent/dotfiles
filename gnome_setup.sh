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
apt_add_new_ppa "tiheum" "equinox"
# Cortina (wallpaper switcher)
apt_add_new_ppa "cs-sniffer" "cortina"

# Queue or install apt packages
apt_queue_or_install "faenza-icon-theme
compiz compizconfig-settings-manager cortina
ttf-droid ttf-inconsolata"

echo "==== Loading font preferences..."
gconftool-2 --load assets/gnome_fonts_conf.xml

echo "==== Loading compiz preferences..."
echo "     (to update these preferences, run: gconftool-2 --dump /apps/compiz > assets/compiz_conf.xml)"
gconftool-2 --load assets/compiz_conf.xml


echo "==== Configuring cortina settings & run on startup..."
cat > ~/.config/Cortina/Cortina.conf <<EOF
[General]
listWidget_Dirs=$HOME/Dropbox/Wallpapers
listWidget_Dirs_flags=2
checkBox_changeWPOnStartup=2
checkBox_loadOnStartup=2
horizontalSlider_interval=7
comboBox_wpstyle=0
randomOrNot=2
EOF

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

