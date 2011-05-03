#!/bin/bash
# Sets up gedit for RoR development.
# -------------------------------------------
echo "== Setting up gedit customizations (RoR colors, etc)..."

this_dir=$(pwd)

# Kill all running gedit processes
killall gedit

# Add ubuntu-on-rails ppa
if ! (apt-cache search gedit-gmate | grep gedit-gmate); then
    sudo apt-add-repository ppa:ubuntu-on-rails/ppa
    sudo apt-get update
fi
echo "Installing gedit-gmate..."
sudo apt-get install -y gedit-gmate

echo "Copying extra gedit plugins and colors..."
mkdir -p ~/.gnome2/gedit/plugins
mkdir -p ~/.gnome2/gedit/styles
cp -R $this_dir/assets/gedit_plugins/* ~/.gnome2/gedit/plugins
cp $this_dir/assets/ndb_rails.xml.geditcolors ~/.gnome2/gedit/styles/ndb_rails.xml

echo "Configuring gedit preferences and plugin settings..."
echo "(to update these preferences, run: gconftool-2 --dump /apps/gedit-2 > assets/gedit-2.conf.xml)"
gconftool-2 --load assets/gedit-2.conf.xml
# Set gedit root dir to current $HOME/src
gconftool-2 --set /apps/gedit-2/plugins/filebrowser/on_load/virtual_root -t string file:///$HOME/src

echo "=== Done."

