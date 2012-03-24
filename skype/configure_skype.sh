#!/bin/bash
source "$DOTFILES_PATH/skype/_skype_shared.sh"

# Configure <UI> key (libnotify notifications) in skype config.

echo "Setting up Skype libnotify notifications for $skype_username..."

tmp_file=$(mktemp)

# Replace <UI> key from existing config with saved config
sed -n '1h; 1!H; ${ g; s%\n\s*<UI>.*</UI>%% p }' "$config_file" | \
sed -e "/<\/Lib>/r $ui_config" > "$tmp_file"
mv "$tmp_file" "$config_file"
