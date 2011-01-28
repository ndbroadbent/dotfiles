#!/bin/bash

# Install tabsextend plugin
cd /tmp
wget "http://gedit-tabsextend.googlecode.com/files/gedit-tabsextend-0.1.tar.gz" -O  gedit-tabsextend.tar.gz
cd nuxlli-gedit*
cp -f * /home/ndbroadbent/.gnome2/gedit/plugins/
cd ..
rm -rf nuxlli-gedit*
rm -f gedit-tabsextend.tar.gz

# Sets up gedit for RoR development.
# (prompt-less version of gmate 'install.sh')
# ===========================================================

SCRIPT_DIR=$(pwd)
cd /tmp
echo "==== Cloning gmate repository.."
git clone git://github.com/lexrupy/gmate.git
cd gmate
echo "==== Setting up gedit plugins and configuration."
    # Kill all runing instances if exists
    killall gedit
    
    sudo cp mime/rails.xml /usr/share/mime/packages
    sudo cp lang-specs/*.lang /usr/share/gtksourceview-2.0/language-specs/
    sudo mkdir -p /usr/share/gedit-2/gmate
    sudo cp gmate.py /usr/share/gedit-2/gmate/gmate.py
    if [ ! -d /usr/share/gedit-2/plugins/taglist/ ]
    then
      sudo mkdir -p /usr/share/gedit-2/plugins/taglist/
    fi
    sudo cp tags/*.tags.gz /usr/share/gedit-2/plugins/taglist/
    sudo update-mime-database /usr/share/mime
    if [ ! -d $HOME/.gnome2/gedit ]
    then
      mkdir -p ~/.gnome2/gedit
    fi
    if [ ! -d $HOME/.gnome2/gedit/snippets ]
    then
      mkdir -p ~/.gnome2/gedit/snippets
    fi
    cp snippets/* ~/.gnome2/gedit/snippets/
    if [ ! -d $HOME/.gnome2/gedit/plugins ]
    then
      mkdir -p ~/.gnome2/gedit/plugins
    fi
    cp -R plugins/* ~/.gnome2/gedit/plugins
    if [ ! -d $HOME/.gnome2/gedit/styles ]
    then
      mkdir -p ~/.gnome2/gedit/styles
    fi
    cp styles/* ~/.gnome2/gedit/styles
    cp $SCRIPT_DIR/geditcolors_nathan.xml ~/.gnome2/gedit/styles/nathan.xml

    sudo sh ./debian/postinst
    gconftool-2 --set /apps/gedit-2/plugins/active-plugins -t list --list-type=str [rails_extract_partial,rubyonrailsloader,align,smart_indent,text_tools,completion,quickhighlightmode,gemini,trailsave,rails_hotkeys,snapopen,filebrowser,snippets,modelines,smartspaces,docinfo,time,spell,terminal,drawspaces,codecomment,colorpicker,indent]
    gconftool-2 --set /apps/gedit-2/preferences/editor/auto_indent/auto_indent -t bool true
    gconftool-2 --set /apps/gedit-2/preferences/editor/bracket_matching/bracket_matching -t bool true
    gconftool-2 --set /apps/gedit-2/preferences/editor/current_line/highlight_current_line -t bool true
    gconftool-2 --set /apps/geditcd ~-2/preferences/editor/cursor_position/restore_cursor_position -t bool true
    gconftool-2 --set /apps/gedit-2/preferences/editor/line_numbers/display_line_numbers -t bool true
    gconftool-2 --set /apps/gedit-2/preferences/editor/right_margin/display_right_margin -t bool false
    gconftool-2 --set /apps/gedit-2/preferences/editor/right_margin/right_margin_position -t int 80
    gconftool-2 --set /apps/gedit-2/preferences/editor/colors/scheme -t str nathan
    gconftool-2 --set /apps/gedit-2/preferences/editor/tabs/insert_spaces -t bool true
    gconftool-2 --set /apps/gedit-2/preferences/editor/tabs/tabs_size -t int 4
    gconftool-2 --set /apps/gedit-2/preferences/editor/wrap_mode/wrap_mode -t str GTK_WRAP_NONE
    gconftool-2 --set /apps/gedit-2/preferences/editor/save/create_backup_copy -t bool false
cd ..
rm -rf gmate

