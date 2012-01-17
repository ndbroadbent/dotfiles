#!/bin/bash
if [ -z `which rvm` ]; then
  echo "== Installing rvm and ruby 1.9.2..."
  bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
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
src_dir=`echo ~/code`
echo "ln -nfs \$rvm_ruby_gem_home/gems $src_dir/current_gemset" > ~/.rvm/hooks/after_use_symlink_gemset

