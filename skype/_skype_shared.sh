#!/bin/bash

# Shared code for skype config scripts

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

config_file="$HOME/.Skype/$skype_username/config.xml"
ui_config="$DOTFILES_PATH/skype/skype-UI.xml"
