#!/bin/bash
echo "== Installing ~/.bashrc & other related dot files..."
this_dir=$(pwd)

# Assemble bashrc from parts
cat assets/bashrc/default.sh > ~/.bashrc
for part in prompt history aliases functions ruby_on_rails crossroads design; do
  cat assets/bashrc/$part.sh >> ~/.bashrc
done

# Add Git Breeze scripts
for part in git_file_shortcuts git_repo_management aliases bash/completions_and_bindings; do
  cat assets/git_breeze/$part.sh >> ~/.bashrc
done


# Append dynamic update command
cat >> ~/.bashrc <<EOF
# Update this file from GitHub
alias pull_bashrc='cd $this_dir && git pull origin master && . bashrc_setup.sh && cd -'
EOF

# Copy other related *rc files
cp -f assets/inputrc ~/.inputrc
cp -f assets/ackrc ~/.ackrc

# If run from dev_machine_setup, we cannot update current shell.
if ! [[ "$0" =~ "dev_machine_setup.sh" ]]; then
  # If this script was sourced properly from the terminal, update current shell
  if [[ "$0" == *bash ]]; then
    source ~/.bashrc
  else
    echo "===== Please run this command to update your current shell: $ source ~/.bashrc"
    echo "      In the future, you should run this script like this:  $ . bashhrc_setup.sh"
  fi
fi

