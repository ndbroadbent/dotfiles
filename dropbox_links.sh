#!/bin/bash
. _shared.sh
# Create symlinks for Dropbox synced directories
# ----------------------------------------------
echo "== Creating Dropbox symlinks..."

rm -f /home/$USER/Design
rm -f /home/$USER/.ssh
rm -f /home/$USER/.gtk-bookmarks
ln -fs /home/$USER/Dropbox/Design /home/$USER/Design
ln -fs /home/$USER/Dropbox/UbuntuSync/ssh /home/$USER/.ssh
ln -fs /home/$USER/Dropbox/UbuntuSync/gtk-bookmarks /home/$USER/.gtk-bookmarks

