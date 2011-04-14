#!/bin/bash
this_dir=$(pwd)

# Sets up gedit for RoR development.
# -------------------------------------------

# Kill all running gedit processes
killall gedit

# Add ubuntu-on-rails ppa
if ! (apt-cache search gedit-gmate); then
    sudo apt-add-repository ppa:ubuntu-on-rails/ppa
    sudo apt-get update
fi
# Install gedit-gmate
sudo apt-get install -y gedit-gmate

# Install tabsextend plugin
if ! (ls ~/.gnome2/gedit/plugins/ | grep tabs_extend); then
    cd /tmp
    wget "http://gedit-tabsextend.googlecode.com/files/gedit-tabsextend-0.1.tar.gz" -O  gedit-tabsextend.tar.gz
    tar -zxvf gedit-tabsextend.tar.gz
    cd nuxlli-gedit*
    cp -f * ~/.gnome2/gedit/plugins/
    cd ..
    rm -rf nuxlli-gedit*
    rm -f gedit-tabsextend.tar.gz
fi

# Configure enabled plugins.
gconftool-2 --set /apps/gedit-2/plugins/active-plugins -t list --list-type=str \
[quickhighlightmode,smart_indent,completion,snapopen,gemini,text_tools,rubyonrailsloader,align,\
FindInFiles,pastie,rails_extract_partial,reopen-tabs,tabs_extend,trailsave,filebrowser,\
regex_replace,taglist,snippets,time,docinfo,rails_hotkeys,gedit_openfiles,modelines]

# Configure gedit editor settings.
gconftool-2 --set /apps/gedit-2/preferences/editor/auto_indent/auto_indent -t bool true
gconftool-2 --set /apps/gedit-2/preferences/editor/bracket_matching/bracket_matching -t bool true
gconftool-2 --set /apps/gedit-2/preferences/editor/current_line/highlight_current_line -t bool true
gconftool-2 --set /apps/gedit-2/preferences/editor/cursor_position/restore_cursor_position -t bool true
gconftool-2 --set /apps/gedit-2/preferences/editor/line_numbers/display_line_numbers -t bool true
gconftool-2 --set /apps/gedit-2/preferences/editor/right_margin/display_right_margin -t bool false
gconftool-2 --set /apps/gedit-2/preferences/editor/right_margin/right_margin_position -t int 80
gconftool-2 --set /apps/gedit-2/preferences/editor/tabs/insert_spaces -t bool true
gconftool-2 --set /apps/gedit-2/preferences/editor/tabs/tabs_size -t int 2
gconftool-2 --set /apps/gedit-2/preferences/editor/wrap_mode/wrap_mode -t str GTK_WRAP_NONE
gconftool-2 --set /apps/gedit-2/preferences/editor/save/create_backup_copy -t bool false

# Setup my gedit RoR colors.
cp $this_dir/ndb_rails.xml.geditcolors ~/.gnome2/gedit/styles/ndb_rails.xml
gconftool-2 --set /apps/gedit-2/preferences/editor/colors/scheme -t str ndb_rails

