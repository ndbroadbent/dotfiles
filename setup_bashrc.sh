#!/bin/bash
cp -f custom_bashrc ~/.custom_bashrc
# Check if ubuntu_bashrc is already installed.
if ! grep ". ~/.custom_bashrc" ~/.bashrc; then
    echo ". ~/.custom_bashrc" >> ~/.bashrc
    echo "== Installed custom bashrc."
else
    echo "== Updated custom bashrc."
fi
echo "== Please run this command to update your terminal : source ~/.bashrc"

