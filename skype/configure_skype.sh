#!/bin/bash

# Configure skype config.

skype_username="$1"
if [ -z "$skype_username" ]; then
  echo "Usage: $0 <skype username>"
  exit 1
fi

config_file="$HOME/.Skype/$skype_username/config.xml"
ui_config="$DOTFILES_PATH/skype/skype-UI.xml"
tmp_file=$(mktemp)

# Replace <UI> key from existing config with saved config
sed -n '1h; 1!H; ${ g; s%\n\s*<UI>.*</UI>%% p }' "$config_file" | \
sed -e "/<\/Lib>/r $ui_config" > "$tmp_file"
mv "$tmp_file" "$config_file"
