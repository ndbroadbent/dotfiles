#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;

sudo apt-get install -ym notification-daemon
sudo mv /usr/lib/notify-osd/notify-osd /usr/lib/notify-osd/notify-osd-default
sudo ln -s /usr/lib/notification-daemon/notification-daemon /usr/lib/notify-osd/notify-osd
# kill notify-osd so that on reload it is replaced with notification-daemon
killall -9 notify-osd