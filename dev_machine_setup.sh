#!/bin/bash
# This bash script will run all the commands to
# setup your development environment on Ubuntu (v=>9.10)

echo "[ Ubuntu Developer Setup Script ]"
echo -e "=================================\n"
read -p "Please enter your name (for git account):"
git_name="$REPLY"
read -p "Please enter your email (for git account):"
git_email="$REPLY"
echo

read -p "Set up gedit customizations? (default='y') (y/n):"
setup_gedit="$REPLY"
read -p "Set up gtk themes and fonts? (default='y') (y/n):"
setup_themes="$REPLY"
read -p "Set up conky (system stats)? (default='y') (y/n):"
setup_conky="$REPLY"
read -p "Set up reddit wallpapers? (default='y') (y/n):"
setup_wallpapers="$REPLY"

echo "== Please enter your sudo password =>"
sudo echo "== Thanks. Now let me install some things for you..."

echo "== Installing required software and development packages."
sudo apt-get update
sudo apt-get -ym install git-core gitk libyaml-ruby \
libzlib-ruby libopenssl-ruby libxslt1-dev libxml2-dev \
ack-grep vim gedit-plugins xclip gtk-theme-switch mysql-server libmysql-ruby \
libmysqlclient15-dev imagemagick libsqlite3-dev sqlite3 \
sun-java6-jdk apache2 python python-dev python-gtk2 python-gtk2-dev \
python-webkit python-webkit-dev python-pyinotify \
conky-all

echo "== Setting up git and ssh..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global branch.master.remote origin
git config --global branch.master.merge refs/heads/master
ssh-keygen -t rsa -C "$git_email"

echo "== Installing custom bashrc..."
./bashrc_setup.sh


echo "== Setting up ~/ config files..."
# Require colors for capistrano
echo "require 'capistrano_colors'" > ~/.caprc
# Autotest config
cat > ~/.autotest <<EOF
Autotest.add_hook :initialize do |at|
  %w{.svn .hg .git vendor}.each {|exception| at.add_exception(exception)}
end
EOF
# Set .gemrc to use --no-ri and --no-rdoc
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
# Conky system monitor
cp assets/conkyrc ~/.conkyrc


if [ -z `which rvm` ]; then
  echo "== Installing rvm and ruby 1.9.2..."
  bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # Loads RVM into shell
  rvm install 1.9.2
  rvm use 1.9.2
else
  echo == "RVM already installed."
fi

echo "== Installing rails and other commonly used gems..."
gem install rails cucumber cucumber-rails spree \
gemcutter authlogic sqlite3-ruby mime-types rmagick \
capistrano capistrano_colors mislav-will_paginate ruby-debug \
heroku mechanize nokogiri

if [ "$setup_gedit" != "n" ] && [ "$setup_gedit" != "no" ]; then
  echo "== Setting up gedit customizations (RoR colors, etc)..."
  ./gedit_setup.sh
else
  echo "==! Skipping gedit setup."
fi

if [ "$setup_themes" != "n" ] && [ "$setup_themes" != "no" ]; then
  echo "== Setting up gtk fonts and themes..."
  ./gtk_setup.sh
else
  echo "==! Skipping gtk fonts and themes setup."
fi

if [ "$setup_conky" != "n" ] && [ "$setup_conky" != "no" ]; then
  echo "== Setting up conky..."
  ./conky_setup.sh
else
  echo "==! Skipping conky setup."
fi

if [ "$setup_wallpapers" != "n" ] && [ "$setup_wallpapers" != "no" ]; then
  echo "== Setting up reddit wallpapers..."
  ./reddit_wallpapers_setup.sh
else
  echo "==! Skipping reddit wallpapers setup."
fi


echo -e "\n===== Ubuntu development machine has been set up!"

