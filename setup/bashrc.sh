#!/bin/bash
CURRENT_DIR=$(pwd)

echo "=> Setting up ~/.bash_profile..."
cat > ~/.bash_profile <<EOF
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
source "$HOME/.bashrc"
EOF

echo "=> Setting up ~/.bashrc..."
cat > ~/.bashrc <<EOF
# Export path of dotfiles repo
export DOTFILES_PATH="${CURRENT_DIR}"
source "\$DOTFILES_PATH/bashrc/main.sh"
EOF
