#!/bin/bash
. _shared.sh
# Sets up gedit for RoR development.
# -------------------------------------------
echo "== Setting up gedit plugins, settings and assets (RoR colors, etc)..."

this_dir=$(pwd)
killall -q gedit

# Add ppa and install packages
apt_add_new_ppa "ubuntu-on-rails" "ppa"
apt_queue_or_install "gedit-gmate"

echo "==== Copying extra gedit plugins and colors..."
mkdir -p ~/.gnome2/gedit/plugins
mkdir -p ~/.gnome2/gedit/styles
# Remove old 'FindInFiles' plugin
sudo rm -f /usr/lib/gedit-2/plugins/FindInFiles*
cp -R $this_dir/assets/gedit_plugins/* ~/.gnome2/gedit/plugins
cp $this_dir/assets/ndb_rails.xml.geditcolors ~/.gnome2/gedit/styles/ndb_rails.xml

echo "==== Loading gedit preferences and plugin settings..."
echo "     (to update these preferences, run: gconftool-2 --dump /apps/gedit-2 > assets/gedit_conf.xml)"
gconftool-2 --load assets/gedit_conf.xml
# Set gedit root dir to $HOME/src
gconftool-2 --set /apps/gedit-2/plugins/filebrowser/on_load/virtual_root -t string file:///$HOME/src

