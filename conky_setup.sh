#!/bin/bash
# Install conky & conky-colors
this_dir=`pwd`
sudo apt-get install -ym conky-all
if (which conky-colors); then
  echo "== conky-colors is already installed."
else
  echo "== Installing conky-colors from source..."
  wget http://gnome-look.org/CONTENT/content-files/92328-conky_colors-5.0.tar.gz -O /tmp/conky_colors.tar.gz
  cd /tmp
  tar zxvf conky_colors.tar.gz
  cd conky_colors
  make
  sudo make install
  rm -rf /tmp/conky_colors /tmp/conky_colors.tar.gz
  echo "===== Installed conky-colors."
fi
cd $this_dir

# Copy conky config files.
rm -rf ~/.conkycolors
cp -rf assets/conkycolors ~/.conkycolors

echo -e "== Add the following command to your startup applications:\n    conky -c ~/.conkycolors/conkyrc"

