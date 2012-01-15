#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
# Install Gnome preferences
# -------------------------------------------
echo "== Setting up gnome preferences..."

echo "==== Setting terminal preferences..."
echo "     (to update these preferences, run: gconftool-2 --dump /apps/gnome-terminal > ubuntu/terminal_conf.xml)"
gconftool-2 --load ubuntu/terminal_conf.xml

echo "==== Setting up gnome panels..."
echo "     (to update these preferences, run: gconftool-2 --dump /apps/panel > ubuntu/panel_conf.xml)"
gconftool-2 --load ubuntu/panel_conf.xml

echo "==== Setting up power manager settings..."
echo "     (to update these preferences, run: gconftool-2 --dump /apps/gnome-power-manager > ubuntu/power_manager_conf.xml)"
gconftool-2 --load ubuntu/power_manager_conf.xml

echo "==== Copying nautilus UI preferences (adds more toolbar buttons)..."
sudo cp -f ubuntu/nautilus_ui.xml /usr/share/nautilus/ui/nautilus-navigation-window-ui.xml

echo "==== Copying themes..."
mkdir -p ~/.themes
cp -rf ubuntu/gtk_themes/* ~/.themes

echo "==== Installing icons, fonts & software..."
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

echo "==== Loading compiz preferences..."
echo "     (to update these preferences, run: gconftool-2 --dump /apps/compiz > ubuntu/compiz_conf.xml)"
gconftool-2 --load ubuntu/compiz_conf.xml

echo "==== Configuring cortina settings & run on startup..."
mkdir -p ~/.config/Cortina
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

mkdir -p ~/.config/autostart
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

echo "==== Setting fonts..."
gconftool-2 --load ubuntu/gnome_fonts_conf.xml
echo "==== Setting icons..."
gconftool-2 --type=string -s /desktop/gnome/interface/icon_theme "Faenza-Darkest"
echo "==== Setting GTK & Metacity themes..."
gconftool-2 --type=string -s /desktop/gnome/interface/gtk_theme "BSM Simple Dark Menu"
gconftool-2 --type=string -s /apps/metacity/general/theme "Clearlooks"

echo "==== Setting GL Slideshow image directory to ~/Dropbox/Wallpapers..."
echo "imageDirectory: $HOME/Dropbox/Wallpapers" > ~/.xscreensaver

