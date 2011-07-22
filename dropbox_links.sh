#!/bin/bash
. _shared.sh
# Create symlinks for Dropbox synced directories
# ----------------------------------------------
echo "== Creating Dropbox symlinks..."

ln -fs /home/$USER/Dropbox/Design /home/$USER/Design
ln -fs /home/$USER/Dropbox/UbuntuSync/ssh /home/$USER/.ssh
ln -fs /home/$USER/Dropbox/UbuntuSync/gtk-bookmarks /home/$USER/.gtk-bookmarks

