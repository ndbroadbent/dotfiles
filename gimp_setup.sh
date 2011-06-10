#!/bin/bash
. _shared.sh
# Install latest version of Gimp
# -------------------------------------------
echo "== Installing latest version of gimp from ppa..."

apt_add_new_ppa "matthaeus123" "mrw-gimp-svn"
apt_queue_or_install "gimp"

