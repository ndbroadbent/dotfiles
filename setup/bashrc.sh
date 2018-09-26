#!/bin/bash
echo "== Installing ~/.bashrc ..."
this_dir=$(pwd)

# Header
cat > ~/.bashrc <<EOF
# Export path of dotfiles repo
export DOTFILES_PATH="$this_dir"
source "\$DOTFILES_PATH/bashrc/main.sh"
EOF

# If this script was sourced from the terminal, update current shell
if ! [[ "$0" =~ "dev_machine_setup.sh" ]] && [[ "$0" == *bash ]]; then
  source ~/.bashrc
fi
