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

# Create conky start script.
cat > ~/.start_conky <<EOF
#!/bin/sh
sleep 10 && conky -c $HOME/.conkycolors/conkyrc
EOF
chmod +x ~/.start_conky

# Set home directory placeholder
sed "s%@HOME@%$HOME%g" -i ~/.conkycolors/conkyrc

# Find out how many CPUs this computer has, and set the @CPU@ placeholder to the correct template.
cpus=`grep ^processor -i /proc/cpuinfo | wc -l`
if [ $cpus -eq 1 ]; then
  awk '/@CPU@/{system("cat ~/.conkycolors/1cpu");next}1' ~/.conkycolors/conkyrc > /tmp/conkyrc && \
  mv /tmp/conkyrc ~/.conkycolors/conkyrc
else
  awk '/@CPU@/{system("cat ~/.conkycolors/2cpu");next}1' ~/.conkycolors/conkyrc > /tmp/conkyrc && \
  mv /tmp/conkyrc ~/.conkycolors/conkyrc
fi

echo -e "== Add the following command to your startup applications:\n    $HOME/.start_conky"

