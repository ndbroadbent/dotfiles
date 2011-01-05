#!/bin/bash
# Check if ndb_bashrc is already installed.
if ! grep ". ~/.ndb_bashrc" ~/.bashrc; then
    echo "== Installing custom bashrc extension.."
    cp -f ndb_bashrc ~/.ndb_bashrc
    echo ". ~/.ndb_bashrc" >> ~/.bashrc
    echo "===== Installed."
else
    cp -f ndb_bashrc ~/.ndb_bashrc
    echo "== Custom bashrc extension updated."
fi
