#!/bin/bash
cp -f ubuntu_bashrc ~/.ubuntu_bashrc
# Check if ubuntu_bashrc is already installed.
if ! grep ". ~/.ubuntu_bashrc" ~/.bashrc; then
    echo ". ~/.ubuntu_bashrc" >> ~/.bashrc
    echo "== Installed custom bashrc."
else
    echo "== Updated custom bashrc."
fi
echo "== Please run this command to update your terminal : source ~/.bashrc"

