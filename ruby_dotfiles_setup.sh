#!/bin/bash
echo "== Setting up ~/.xxxxxx config files..."

# Rubygems
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# RVM
cat > ~/.rvmrc <<EOF
export rvm_path="`echo ~/.rvm`"
rvm_trust_rvmrcs_flag=1
EOF

# Ruby-debug
cat > ~/.rdebugrc <<EOF
set autoeval
set autolist
set autoreload
EOF

# Capistrano
echo "require 'capistrano_colors'" > ~/.caprc

# Autotest
cat > ~/.autotest <<EOF
Autotest.add_hook :initialize do |at|
  %w{.svn .hg .git vendor}.each {|exception| at.add_exception(exception)}
end
EOF

