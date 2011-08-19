#!/bin/bash
echo "== Installing ~/.zshrc..."
this_dir=$(pwd)

echo -n > ~/.zshrc
# Include zshrc parts from ubuntu_config
for part in default; do # history aliases src_management functions; do
  echo ". $this_dir/assets/zshrc/$part.sh" >> ~/.zshrc
done

# Append dynamic update command
cat >> ~/.zshrc <<EOF
# Update this file from GitHub
alias pull_bashrc='cd $this_dir && git pull origin master && . bashrc_setup.sh && cd -'
EOF

# Copy other related *rc files
cp -f assets/inputrc ~/.inputrc
cp -f assets/ackrc ~/.ackrc

# If run from dev_machine_setup, we cannot update current shell.
if ! [[ "$0" =~ "dev_machine_setup.sh" ]]; then
  # If this script was sourced properly from the terminal, update current shell
  if [[ "$0" = "zsh" ]]; then
    source ~/.zshrc
  else
    echo "===== Please run this command to update your current shell: $ source ~/.zshrc"
    echo "      In the future, you should run this script like this:  $ . zshrc_setup.sh"
  fi
fi

