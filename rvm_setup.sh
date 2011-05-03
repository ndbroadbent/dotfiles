#!/bin/bash
if [ -z `which rvm` ]; then
  echo "== Installing rvm and ruby 1.9.2..."
  bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # Loads RVM into shell
  rvm install 1.9.2
  rvm use 1.9.2
else
  echo "== Updating rvm..."
  rvm update
fi

