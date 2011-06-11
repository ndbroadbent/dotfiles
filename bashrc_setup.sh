#!/bin/bash
echo "== Installing ~/.bashrc & ~/.inputrc..."
this_dir=$(pwd)

# Assemble bashrc from parts
cat assets/bashrc/default.sh > ~/.bashrc
bashrc_parts=(prompt history aliases src_management functions);
for part in "${bashrc_parts[@]}"; do
  cat assets/bashrc/$part.sh >> ~/.bashrc
done
# Append dynamic update command
cat >> ~/.bashrc <<EOF
# Update this file from GitHub
alias pull_bashrc='cd $this_dir && git pull origin master && . bashrc_setup.sh && cd -'
EOF

# Copy inputrc
cp -f assets/inputrc.sh ~/.inputrc

# If run from dev_machine_setup, we cannot update current shell.
if ! [[ "$0" =~ "dev_machine_setup.sh" ]]; then
  # If this script was sourced properly from the terminal, update current shell
  if [[ "$0" = "bash" ]]; then
    source ~/.bashrc
  else
    echo "===== Please run this command to update your current shell: $ source ~/.bashrc"
    echo "      In the future, you should run this script like this:  $ . bashhrc_setup.sh"
  fi
fi

