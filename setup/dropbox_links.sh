#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
# Create symlinks for Dropbox synced directories
# ----------------------------------------------
echo "== Creating Dropbox symlinks..."

rm -rf /home/$USER/Design
rm -rf /home/$USER/.ssh
rm -rf /home/$USER/.gtk-bookmarks
ln -fs /home/$USER/Dropbox/Design /home/$USER/Design
ln -fs /home/$USER/Dropbox/UbuntuSync/ssh /home/$USER/.ssh
ln -fs /home/$USER/Dropbox/UbuntuSync/gtk-bookmarks /home/$USER/.gtk-bookmarks

