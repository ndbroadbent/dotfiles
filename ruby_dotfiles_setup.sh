#!/bin/bash
echo "== Setting up ~/.***** config files..."

# No gem docs
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Capistrano colors
echo "require 'capistrano_colors'" > ~/.caprc

# Autotest
cat > ~/.autotest <<EOF
Autotest.add_hook :initialize do |at|
  %w{.svn .hg .git vendor}.each {|exception| at.add_exception(exception)}
end
EOF

