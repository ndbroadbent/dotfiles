#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
apt_add_dependency "curl"

# Install required Ruby Libraries
apt_queue_or_install "libyaml-ruby libzlib-ruby libreadline-dev libruby \
imagemagick libmagickwand-dev libmagickcore-dev libxslt1-dev libxml2-dev"

if [ -z `which rvm` ]; then
  echo "== Installing rvm and ruby 1.9.2..."
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # Loads RVM into shell
  rvm install 1.9.2
  rvm use 1.9.2 --default
else
  echo "== Updating rvm..."
  rvm get latest
fi

# RVM after_use hook: updates a symlink to point to the current gemset
# ---------------------------------------------------------------------
mkdir -p ~/.rvm/hooks
chown $USER:$USER ~/.rvm/hooks
src_dir="$HOME/code"
echo "ln -nfs \$rvm_ruby_gem_home/gems $src_dir/current_gemset" > ~/.rvm/hooks/after_use_symlink_gemset

