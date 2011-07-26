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


# Sync Firefox profile (just extensions / preferences / etc)
# ----------------------------------------------------------
mkdir -p ~/.mozilla/firefox
profile=$(grep "Path=" ~/.mozilla/firefox/profiles.ini | sed "s/Path=//g")
if [ -n "$profile" ]; then
  profile_path=/home/$USER/.mozilla/firefox/$profile
  for file in /home/$USER/Dropbox/UbuntuSync/firefox_profile/*; do
    rm -rf $profile_path/$(basename $file)
    ln -fs $file $profile_path/$(basename $file)
  done
fi

