#!/bin/bash

# RVM after_use hook: updates a symlink to point to the current gemset
# ---------------------------------------------------------------------
mkdir -p $HOME/.rvm/hooks
chown $USER:$USER $HOME/.rvm/hooks
src_dir="$HOME/code"
cat > $HOME/.rvm/hooks/after_use_symlink_gemset <<EOF
rm -f $HOME/code/current_gemset
ln -fs \$rvm_ruby_gem_home/gems $HOME/code/current_gemset
EOF
chmod +x $HOME/.rvm/hooks/after_use_symlink_gemset
