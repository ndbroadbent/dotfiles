#!/bin/bash
source "$DOTFILES_PATH/skype/_skype_shared.sh"

# Fetch config from skype and update stored settings

echo "Fetching Skype <UI> config for $skype_username..."

sed -n -e '1h; 1!H; ${ g; s%.*\(  <UI>.*</UI>\).*%\1% p }' "$config_file" > "$ui_config"
