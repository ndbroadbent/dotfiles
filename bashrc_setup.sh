#!/bin/bash
cp -f custom_bashrc ~/.custom_bashrc
# Check if ubuntu_bashrc is already installed.
if ! (grep ". ~/.custom_bashrc" ~/.bashrc); then
    echo ". ~/.custom_bashrc" >> ~/.bashrc
    echo "== Installed custom bashrc."
else
    echo "== Updated custom bashrc."
fi
source ~/.bashrc

echo "== If you did not run: [ . bashrc_setup.sh ], then run this command: [ source ~/.bashrc ]"

echo "
[Desktop Entry]
Name=bashrc Github Sync
GenericName=bashrc Github Sync
Comment=Sync bashrc with github repo
Exec=cd $(pwd) && git pull origin master && ./bashrc_setup.sh
Type=Application
Categories=Network;
StartupNotify=false" > ~/.config/autostart/update_bashrc.desktop

