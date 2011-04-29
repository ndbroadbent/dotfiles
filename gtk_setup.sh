#!/bin/bash
this_dir=$(pwd)
cp -rf assets/gtk_themes/* ~/.themes

if [ -z `which gtk-theme-switch2` ]; then
  echo "== Install gtk-theme-switch with this command:"
  echo "        sudo apt-get install gtk-theme-switch"; echo
fi

echo "== Change themes with the following command:"
echo "        gtk-theme-switch2 ~/.themes/*******"

