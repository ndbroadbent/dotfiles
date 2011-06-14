#!/bin/bash
. _shared.sh
apt_add_new_ppa "jtaylor" "keepass"
apt_queue_or_install keepass2

