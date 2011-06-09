#!/bin/bash
echo "== Installing custom bashrc (and inputrc)..."
this_dir=$(pwd)
# Copy custom_bashrc as well as inputrc with readline key bindings
cp -f assets/custom_bashrc.sh ~/.custom_bashrc
cp -f assets/inputrc.sh ~/.inputrc

# Update the 'update' command in custom_bashrc with the current directory.
sed -i s#--UBUNTUCONF_DIR--#$this_dir#g ~/.custom_bashrc

# Check if ubuntu_bashrc is already installed.
if ! (grep -q ". ~/.custom_bashrc" ~/.bashrc); then
  echo ". ~/.custom_bashrc" >> ~/.bashrc
  echo "===== Installed custom bashrc."
else
  echo "===== Updated custom bashrc."
fi
source ~/.bashrc

echo "===== If you did not run: [ . bashrc_setup.sh ], please run this command: [ source ~/.bashrc ]"

