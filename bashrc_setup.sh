#!/bin/bash
cp -f custom_bashrc ~/.custom_bashrc
# Check if ubuntu_bashrc is already installed.
if ! (grep ". ~/.custom_bashrc" ~/.bashrc); then
    echo "alias pull_bashrc='cd $(pwd) && git pull origin master && ./bashrc_setup.sh'" >> ~/.bashrc
    echo ". ~/.custom_bashrc" >> ~/.bashrc
    echo "== Installed custom bashrc."
else
    echo "== Updated custom bashrc."
fi
source ~/.bashrc

echo "== If you did not run: [ . bashrc_setup.sh ], then run this command: [ source ~/.bashrc ]"

