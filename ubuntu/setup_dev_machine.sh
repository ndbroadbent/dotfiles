#!/bin/bash
# This bash script will run all the commands to
# setup your development environment on Ubuntu (v=>9.10)

echo "[ Starting installation script... ]"
read -p "Please enter your name (for git account):"
git_name="$REPLY"
read -p "Please enter your email (for git account):"
git_email="$REPLY"
echo "== Please enter your sudo password =>"
sudo echo "== Thanks. Now let me install some things for you..."

echo "== Installing required software and development packages."
sudo apt-get update
sudo apt-get -ym install git-core gitk libyaml-ruby \
libzlib-ruby libopenssl-ruby libxslt1-dev libxml2-dev \
ack-grep vim gedit-plugins xclip mysql-server libmysql-ruby \
libmysqlclient15-dev imagemagick libsqlite3-dev sqlite3 \
sun-java6-jdk apache2 python python-dev python-gtk2 python-gtk2-dev \
python-webkit python-webkit-dev python-pyinotify \
trash-cli

echo "== Installing custom bashrc..."
./setup_bashrc.sh
source ~/.bashrc

echo "== Installing rvm and ruby 1.9.2..."
bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

rvm install 1.9.2
rvm use 1.9.2

echo "== Setting up git and ssh.."
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global branch.master.remote origin
git config --global branch.master.merge refs/heads/master
ssh-keygen -t rsa -C "$git_email"

echo "== Installing rails and other commonly used gems.."
gem install rails cucumber cucumber-rails spree \
gemcutter authlogic sqlite3-ruby mime-types rmagick \
capistrano capistrano_colors mislav-will_paginate ruby-debug \
heroku mechanize nokogiri

echo "== Setting up gmate for gedit (RoR colors, etc).."
./setup_gedit.sh

echo "== Setting Capistrano to require colours.."
cat >> ~/.caprc <<!
require 'capistrano_colors'
!

echo "== Setting up autotest config.."
cat >> ~/.autotest <<!
Autotest.add_hook :initialize do |at|
  %w{.svn .hg .git vendor}.each {|exception| at.add_exception(exception)}
end
!

# -- -install-global-extensions has been removed from firefox.
#echo "== Installing Firefox extensions (Firebug and Web Developer Toolbar).."
#cd ~
#wget https://addons.mozilla.org/en-US/firefox/downloads/latest/60/addon-60-latest.xpi?src=addondetail
#wget https://addons.mozilla.org/en-US/firefox/downloads/latest/1843/addon-1843-latest.xpi?src=addondetail
# ~/.mozilla/firefox/<profile folder>/extensions

echo "===== Ubuntu development machine has been set up."
