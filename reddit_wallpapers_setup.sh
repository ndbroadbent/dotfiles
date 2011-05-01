install_dir=/opt/Wallpaper-Downloader-and-Rotator-for-Gnome
photo_dir=~/Pictures/RedditWallpapers/
duration=600

mkdir -p $photo_dir

echo "== Installing required python libraries..."
sudo apt-get -ym install python-beautifulsoup python-lxml

echo "== Downloading and configuring 'Wallpaper-Downloader-and-Rotator-for-Gnome'..."
sudo git clone https://github.com/jabbalaci/Wallpaper-Downloader-and-Rotator-for-Gnome.git $install_dir

cd $install_dir
# Configure script (photo_dir, duration)
sudo sed "s%PHOTO_DIR = '[^']*'%PHOTO_DIR = '$photo_dir'%g" -i background_fetch.py
sudo sed "s%DURATION = '[^']*'%DURATION = '$duration'%g" -i background_fetch.py

# Setting desktop background to generated xml.
gconftool-2 --type string --set /desktop/gnome/background/picture_filename $photo_dir/EarthPorn.xml

# Make script run on startup (if not added already)
if ! (grep -q background_fetch.py /etc/rc.local); then
  sudo sed "s%exit 0$%$install_dir/background_fetch.py\nexit 0%g" -i /etc/rc.local
fi

echo -e "\n===== Please check your '/etc/rc.local' file to make sure the startup process was added correctly.\n"
echo -e "It should look like:\n\n        $install_dir/background_fetch.py\n        exit 0"

