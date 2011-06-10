#!/bin/bash
src_dir=`echo ~/src`

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

# RVM after_use hook: updates a symlink to point to the current gemset
# ---------------------------------------------------------------------
echo "ln -nfs \$rvm_ruby_gem_home/gems $src_dir/current_gemset" > ~/.rvm/hooks/after_use

