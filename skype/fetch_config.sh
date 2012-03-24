#!/bin/bash

# Fetch config from skype and update stored settings

if [ "$1" = "--help" ]; then
  echo "Usage: $0 <skype username>   (if omitted, will detect default username)"
  exit 1
fi

if [ -n "$1" ]; then
  # skype username from arg
  skype_username="$1"
else
  # Find default skype username from skype config
  skype_username="$(grep "<Default>" "$HOME/.Skype/shared.xml" | sed "s/.*>\([^)]*\)<.*/\1/")"
  if [ -z "$skype_username" ]; then
    echo "Default Skype username not found."
    exit 1
  fi
fi

echo "Fetching Skype <UI> config for $skype_username..."

config_file="$HOME/.Skype/$skype_username/config.xml"
ui_config="$DOTFILES_PATH/skype/skype-UI.xml"
tmp_file=$(mktemp)

sed -n -e '1h; 1!H; ${ g; s%.*\(  <UI>.*</UI>\).*%\1% p }' "$config_file" | sed "s/^  //g"  > "$ui_config"
