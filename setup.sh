#!/bin/bash
set -eo pipefail

if [[ $EUID -eq 0 ]]; then
  echo -e "\033[01;31mPlease do not use sudo to run this script!\033[00m" 2>&1
  exit 1
fi

echo -e "Setting up Mac..."
source setup/bashrc.sh
source setup/packages.sh
./setup/mac_settings.sh
source setup/scm_breeze.sh

if [ "$BASH" != "/bin/bash" ]; then
  echo "Changing shell to /bin/bash for ${USER}"
  sudo chsh -s /bin/bash "${USER}"
fi

echo "🍀" > "$HOME/.user_sym"
echo "" > "$HOME/.hostname_sym"

echo "Opening installed applications..."
open -a "/Applications/iTerm.app"
open -a "/Applications/Rectangle.app"
open -a "/Applications/Dozer.app"
open -a "/Applications/Flux.app"
open -a "/Applications/RescueTime.app"
open -a "/Applications/Docker.app"
open -a "/Applications/Dropbox.app"
open -a "/Applications/Backup and Sync.app"
open -a "/Applications/Google Chrome.app"
open -a "App Store"

echo
echo "Next Steps:"
echo "================================="
echo
echo "=> Sign in to Chrome"
echo "  ↪ Sign in to LastPass"
echo "  ↪ Sign in to GitHub"
echo "=> Install Settings Sync extension for VS Code. Sign in with GitHub. Restore settings from this Gist:"
echo "   https://gist.github.com/ndbroadbent/59198ab02dae656842cba3d8392a62ce"
echo
echo "=> Sign in to GitLab"
echo "=> Sign in to the App Store"
echo "  ↪ Run ./setup/mas.sh to install apps from App Store"
echo "=> Sign in to Dropbox"
echo "  ↪ Run 'mackup restore'"
echo "  ↪ Run 'dropbox_backup -r'"
echo "=> Sign in to DocSpring Google Drive"
echo "=> Sign in to Personal Google Drive"
echo "=> Sign in to RescueTime"
echo "=> Sign in to Skype"
echo "=> Sign in to Line"
echo "=> Sign in to Telegram"
echo "=> Sign in to Slack"
echo "=> Sign in to Spotify"
echo
