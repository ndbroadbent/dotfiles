#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
# Install Dropbox Nautilus Extension
# -------------------------------------------
echo "== Installing dropbox nautilus extension..."

if ! (apt-cache search nautilus-dropbox | grep -q nautilus-dropbox); then
  # Dropbox source
  echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" | sudo tee "/etc/apt/sources.list.d/dropbox.list" > /dev/null
  sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
fi

apt_queue_or_install "nautilus-dropbox"

