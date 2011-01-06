#!/bin/bash
cp -f ndb_bashrc ~/.ndb_bashrc
# Check if ndb_bashrc is already installed.
if ! grep ". ~/.ndb_bashrc" ~/.bashrc; then
    echo ". ~/.ndb_bashrc" >> ~/.bashrc
    echo "== Installed custom bashrc."
else
    echo "== Updated custom bashrc."
fi
echo "== Please run this command to update your terminal : source ~/.bashrc"

