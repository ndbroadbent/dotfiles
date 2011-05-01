#!/bin/bash
# Install conky & conky-colors
sudo apt-get install -ym conky-all

# Copy conky files.
cp -rf assets/conkycolors ~/.conkycolors

echo -e "== Add the following command to your startup applications:\n    conky -c ~/.conkycolors/conkyrc"

