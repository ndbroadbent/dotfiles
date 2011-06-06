#!/bin/bash
# Install latest version Gimp
# -------------------------------------------
echo "== Installing latest version of gimp..."

sudo add-apt-repository ppa:matthaeus123/mrw-gimp-svn
sudo apt-get update
sudo apt-get install -ym gimp

