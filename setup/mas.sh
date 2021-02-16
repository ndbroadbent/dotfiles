#!/bin/bash

# Use mas to install apps from Mac App Store (https://github.com/mas-cli/mas)
# See list of installed apps: $ mas list

# read -p "What's your Apple ID? " APPLE_ID
# mas signin --dialog "$APPLE_ID" || true
# Error: The 'signin' command has been disabled on this macOS version. Please sign into the Mac App Store app manually.
# For more info see: https://github.com/mas-cli/mas/issues/164

# Apps:
# ----------------------------------------------------------------
MAC_APP_STORE_APPS=(
  "Spark - Email App"
  "LINE"
  "Kindle"
  "Evernote"
  "WhatsApp Desktop"
)
for APP_NAME in "${MAC_APP_STORE_APPS[@]}"; do
  echo "+ mas search $APP_NAME"
  mas search "$APP_NAME" | grep "$APP_NAME" | head -n1
  echo "=> Installing $APP_NAME..."
  mas lucky "$APP_NAME"
done
