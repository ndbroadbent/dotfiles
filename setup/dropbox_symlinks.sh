#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
# Create symlinks for Dropbox synced directories
# ----------------------------------------------
echo "== Symlinking shared Ubuntu folders from Dropbox..."

rm -rf $HOME/Design
rm -rf $HOME/.ssh
rm -rf $HOME/.gtk-bookmarks
ln -fs $HOME/Dropbox/Design $HOME/Design
ln -fs $HOME/Dropbox/UbuntuSync/ssh $HOME/.ssh
ln -fs $HOME/Dropbox/UbuntuSync/gtk-bookmarks $HOME/.gtk-bookmarks
