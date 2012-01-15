#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
# Sets up gedit for RoR development.
# -------------------------------------------
echo "== Setting up gedit plugins, settings and assets (RoR colors, etc)..."

this_dir=$(pwd)
killall -q gedit

# Add ppa and install packages
apt_queue_or_install "gedit-gmate"

echo "==== Copying extra gedit plugins and colors..."
sudo mkdir -p /usr/lib/gedit/plugins
sudo mkdir -p /usr/lib/gedit/styles
# Remove old 'FindInFiles' plugin
sudo rm -f /usr/lib/gedit/plugins/FindInFiles*
sudo cp -R $this_dir/assets/gedit_plugins/* /usr/lib/gedit/plugins
sudo cp $this_dir/assets/ndb_rails.xml.geditcolors /usr/lib/gedit/styles/ndb_rails.xml
# Installing configured key accelerators
cp $this_dir/assets/gedit_accels ~/.gnome2/accels/gedit

echo "==== Loading gedit preferences and plugin settings..."
echo "     (to update these preferences, run the following command:)"
echo "          gconftool-2 --dump /apps/gedit-2 | sed s/\$USER/@USER@/g > assets/gedit_conf.xml"
# (load config with substituted username)
sed s/@USER@/$USER/g assets/gedit_conf.xml | gconftool-2 --load -
# Set gedit root dir to $HOME/src
gconftool-2 --set /apps/gedit-2/plugins/filebrowser/on_load/virtual_root -t string file:///$HOME/src

