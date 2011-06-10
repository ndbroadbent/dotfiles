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

echo "===== Installed ~/.bashrc & ~/.inputrc."

source ~/.bashrc

echo "===== If you did not run: [ . bashrc_setup.sh ], please run this command: [ source ~/.bashrc ]"

