#!/bin/bash
# This bash script will run all the commands to
# setup your development environment on Ubuntu (v=>9.10)

echo "[ Starting update script... ]"

echo "== Please enter your sudo password =>"
sudo echo "== Thanks. Now let me install some things for you..."

echo "== Updating custom bashrc..."
./bashrc_setup.sh

echo "== Updating gedit customizations (RoR colors, etc).."
./gedit_setup.sh

echo "== Updating gtk fonts and themes.."
./gtk_setup.sh

echo "===== Ubuntu development machine has been updated."

