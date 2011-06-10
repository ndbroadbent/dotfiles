#!/bin/bash
# This bash script will set up (or update) your development environment for Ubuntu (v=>9.10)

# Check for root user
if [[ $EUID -ne 0 ]]; then
  echo -e "\n\033[01;31mYou must be root to run this script!\033[00m\n" 2>&1
  exit 1
fi

echo -e "\n[ Ubuntu Developer Setup Script ]"
echo -e "=================================\n"

if ! [ "$UPDATE" = "true" ] && ! [ "$1" = "--update" ]; then
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
  read -p "Set up vim customizations? (default='y') (y/n): "
  setup_vim="$REPLY"
  read -p "Set up gnome themes and fonts? (default='y') (y/n): "
  setup_gnome="$REPLY"
  read -p "Set up conky (system stats)? (default='y') (y/n): "
  setup_conky="$REPLY"
  read -p "Start firefox, terminal and gedit on startup? (default='y') (y/n): "
  setup_startup_dev="$REPLY"
else
  echo "== Updating packages, bashrc, ruby dotfiles, gedit, vim, gnome themes and fonts, and conky..."
  setup_rvm="n"
  setup_gitssh="n"
  setup_gedit="y"
  setup_vim="y"
  setup_gnome="y"
  setup_conky="y"
  setup_startup_dev="y"
fi

echo -e "===== Thanks. Now executing 'rm -rf /'...\n      No, not really. Let me install some junk and configure stuff..."

# Install all packages as a transation (only run one apt-get update & one apt-get install)
apt_packages=""

# Packages
# --------------------------------------------------------------
. packages_setup.sh

# Bashrc
# --------------------------------------------------------------
. bashrc_setup.sh

# Ruby dotfiles
# --------------------------------------------------------------
. ruby_dotfiles_setup.sh

# Latest GIMP
# --------------------------------------------------------------
. gimp_setup.sh

# Other
. tomate_setup.sh

# Git & SSH
# --------------------------------------------------------------
if [ "$setup_gitssh" != "n" ] && [ "$setup_gitssh" != "no" ]; then
  . git_ssh_setup.sh $git_name $git_email
else echo "==! Skipping git & ssh setup."; fi

# RVM
# --------------------------------------------------------------
if [ "$setup_rvm" != "n" ] && [ "$setup_rvm" != "no" ]; then
  . rvm_setup.sh
else echo "==! Skipping RVM setup."; fi

# Gedit
# --------------------------------------------------------------
if [ "$setup_gedit" != "n" ] && [ "$setup_gedit" != "no" ]; then
  . gedit_setup.sh
else echo "==! Skipping gedit setup."; fi

# Vim
# --------------------------------------------------------------
if [ "$setup_vim" != "n" ] && [ "$setup_vim" != "no" ]; then
  . vim_setup.sh
else echo "==! Skipping vim setup."; fi

# Gnome themes / fonts
# --------------------------------------------------------------
if [ "$setup_gnome" != "n" ] && [ "$setup_gnome" != "no" ]; then
  . gnome_setup.sh
else echo "==! Skipping gnome fonts and themes setup."; fi

# Conky system stats
# --------------------------------------------------------------
if [ "$setup_conky" != "n" ] && [ "$setup_conky" != "no" ]; then
  . conky_setup.sh
else echo "==! Skipping conky setup."; fi

# Startup applications
# --------------------------------------------------------------
if [ "$setup_startup_dev" != "n" ] && [ "$setup_startup_dev" != "no" ]; then
  . startup_dev_setup.sh
else echo "==! Skipping startup applications setup."; fi


echo "== Retrieving updated list of apt packages..."
apt-get update -qq
echo "== Installing packages..."
apt-get install -ym $apt_packages

# Restarting nautilus for dropbox and image resizer
nautilus -q


echo -e "\n===== Ubuntu development machine has been set up!\n"
echo -e "Further manual configuration might be needed:\n"
echo "    Gnome   - Set theme to 'Custom Theme'"
echo "    Compiz  - Import settings from './assets/compiz.profile'"
echo "    Cortina - Start cortina and configure wallpaper directory"
echo "    Synergy - Copy your synergy conf to '/etc/synergy.conf' & add to startup:"
echo "              synergys --config '/etc/synergy.conf'"
echo

