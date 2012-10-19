#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
echo "== Setting up default software packages..."

# -----------------------------------------------------------------------------------
# Base
pkg_base="curl vim htop tmux ack-grep xclip ssh synergy"

# Ruby requirements
pkg_ruby="build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev \
          libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev \
          ncurses-dev automake libtool bison subversion pkg-config"

# Development
pkg_dev="git-core git-gui gitk tig python"

# Databases
pkg_db="postgresql libpq-dev mysql-client libmysqlclient-dev sqlite3 libsqlite3-dev"

# Gnome (OS UI)
pkg_gnome="libnotify-bin python-pyinotify python-webkit python-webkit-dev"

# Applications
pkg_apps="vlc"

# -----------------------------------------------------------------------------------
# Queue or install apt packages
apt_queue_or_install "$pkg_base $pkg_ruby $pkg_dev $pkg_gnome $pkg_apps"

# Add Canonical Partners repository
sudo add-apt-repository "deb http://archive.canonical.com/ $ubuntu_codename partner"
