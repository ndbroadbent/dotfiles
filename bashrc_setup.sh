#!/bin/bash
cp -f custom_bashrc ~/.custom_bashrc
# Update the 'update' command with the current directory. (# delimiter)
this_dir=$(pwd); sed -i s#--MYNIX_DIR--#$this_dir#g ~/.custom_bashrc

# Check if ubuntu_bashrc is already installed.
if ! (grep ". ~/.custom_bashrc" ~/.bashrc); then
    echo ". ~/.custom_bashrc" >> ~/.bashrc
    echo "== Installed custom bashrc."
else
    echo "== Updated custom bashrc."
fi
source ~/.bashrc

echo "== If you did not run: [ . bashrc_setup.sh ], then run this command: [ source ~/.bashrc ]"

