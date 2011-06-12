#!/bin/bash
. _shared.sh
echo "== Setting up default software packages..."

# -----------------------------------------------------------------------------------
# Base
pkg_base="curl vim ack-grep xclip synergy apache2"

# Development
pkg_dev="git-core git-gui gitk tig subversion gedit-plugins python"

# Ruby Libraries
pkg_ruby_libs="libyaml-ruby libzlib-ruby libruby
imagemagick libmagickwand-dev libmagickcore-dev libxslt1-dev libxml2-dev
mysql-server libmysql-ruby libmysqlclient-dev postgresql libpq-dev sqlite3 libsqlite3-dev"

# Gnome (OS UI)
pkg_gnome="libnotify-bin python-pyinotify python-webkit python-webkit-dev
avant-window-navigator avant-window-navigator-data awn-settings
awn-applets-c-core libawn1 vala-awn"

# Addons / Tweaks
pkg_addons="nautilus-image-converter nautilus-open-terminal nautilus-gksu"

# Applications
pkg_apps="vlc thunderbird chromium-browser"

# -----------------------------------------------------------------------------------
# Queue or install apt packages
apt_queue_or_install "$pkg_base $pkg_dev $pkg_ruby_libs $pkg_gnome $pkg_addons $pkg_apps"

