#!/bin/bash
# This bash script will set up your development environment for Ubuntu (v=>9.10)

echo "[ Ubuntu Developer Setup Script ]"
echo -e "=================================\n"

read -p "Set up Git & SSH? (default='y') (y/n): "
setup_gitssh="$REPLY"
if [ "$setup_gitssh" != "n" ] && [ "$setup_gitssh" != "no" ]; then
  echo
  read -p "    Please enter your name (for git account): "
  git_name="$REPLY"
  read -p "    Please enter your email (for git account): "
  git_email="$REPLY"
  echo
fi
read -p "Set up RVM? (default='y') (y/n): "
setup_rvm="$REPLY"
read -p "Set up gedit customizations? (default='y') (y/n): "
setup_gedit="$REPLY"
read -p "Set up gnome themes and fonts? (default='y') (y/n): "
setup_gnome="$REPLY"
read -p "Set up conky (system stats on wallpaper)? (default='y') (y/n): "
setup_conky="$REPLY"

echo -e "\n== Please enter your sudo password: "
sudo echo -e "===== Thanks. Now let me install some things for you...\n"

# Packages
# --------------------------------------------------------------
./packages_setup.sh

# Bashrc
# --------------------------------------------------------------
./bashrc_setup.sh

# Ruby dotfiles
# --------------------------------------------------------------
./ruby_dotfiles_setup.sh

# Git & SSH
# --------------------------------------------------------------
if [ "$setup_gitssh" != "n" ] && [ "$setup_gitssh" != "no" ]; then
  ./git_ssh_setup.sh $git_name $git_email
else echo "==! Skipping git & ssh setup."; fi

# RVM
# --------------------------------------------------------------
if [ "$setup_rvm" != "n" ] && [ "$setup_rvm" != "no" ]; then
  ./rvm_setup.sh
else echo "==! Skipping RVM setup."; fi

# Gedit
# --------------------------------------------------------------
if [ "$setup_gedit" != "n" ] && [ "$setup_gedit" != "no" ]; then
  ./gedit_setup.sh
else echo "==! Skipping gedit setup."; fi

# Gnome themes / fonts
# --------------------------------------------------------------
if [ "$setup_gnome" != "n" ] && [ "$setup_gnome" != "no" ]; then
  ./gnome_setup.sh
else echo "==! Skipping gnome fonts and themes setup."; fi

# Conky system stats
# --------------------------------------------------------------
if [ "$setup_conky" != "n" ] && [ "$setup_conky" != "no" ]; then
  ./conky_setup.sh
else echo "==! Skipping conky setup."; fi


echo -e "\n===== Ubuntu development machine has been set up!\n"
echo -e "Further manual configuration might be needed:\n"
echo "    Gnome  - Set theme to 'Custom Theme'"
echo "    Compiz - Import settings from './assets/compiz.profile'"
echo "    Conky  - Add this command to your startup applications: $HOME/.start_conky"
echo

