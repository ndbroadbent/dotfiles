#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
apt_add_dependency "curl"

# Install required Ruby Libraries
apt_queue_or_install "libreadline-dev libruby \
imagemagick libmagickwand-dev libmagickcore-dev libxslt1-dev libxml2-dev"

if [ -z `which rvm` ]; then
  echo "== Installing rvm and ruby 1.9.2..."
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

  \curl -sSL https://get.rvm.io | bash -s stable --ruby
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # Loads RVM into shell
else
  echo "== Updating rvm..."
  rvm get stable
fi
