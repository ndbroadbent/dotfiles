#!/bin/bash

install_dir=/opt/Wallpaper-Downloader-and-Rotator-for-Gnome
photo_dir=~/Pictures/RedditWallpapers/
duration=600.0

mkdir -p $photo_dir

echo "== Installing required python libraries..."
sudo apt-get -ym install python-beautifulsoup python-lxml

echo "== Downloading and configuring 'Wallpaper-Downloader-and-Rotator-for-Gnome'..."
sudo git clone https://github.com/jabbalaci/Wallpaper-Downloader-and-Rotator-for-Gnome.git $install_dir

cd $install_dir
# Configure script (photo_dir, duration)
sudo sed -e "s%PHOTO_DIR = '[^']*'%PHOTO_DIR = '$photo_dir'%g" \
         -e "s%DURATION = '[^']*'%DURATION = '$duration'%g"  \
         -e "s%SIZE_THRESHOLD = ([^)]*)$%SIZE_THRESHOLD = (1600, 1200)%g" \
         -i background_fetch.py

# Setting desktop background to generated xml.
gconftool-2 --type string --set /desktop/gnome/background/picture_filename $photo_dir/EarthPorn.xml

# Make script run on startup
cat > /tmp/reddit_wallpapers.sh <<EOF
#!/bin/sh
$install_dir/background_fetch.py
EOF
sudo mv /tmp/reddit_wallpapers.sh /etc/init.d/reddit_wallpapers
sudo chmod +x /etc/init.d/reddit_wallpapers
sudo update-rc.d reddit_wallpapers defaults

echo -e "\nTo run the script now:  $ $install_dir/background_fetch.py\n"

