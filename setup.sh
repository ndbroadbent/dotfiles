#!/bin/bash
set -eo pipefail

if [[ $EUID -eq 0 ]]; then
  echo -e "\033[01;31mPlease do not use sudo to run this script!\033[00m" 2>&1
  exit 1
fi

echo -e "Setting up Mac..."
source setup/bashrc.sh
source setup/packages.sh
source setup/mac_settings.sh
source setup/scm_breeze.sh

if [ "$BASH" != "/bin/bash" ]; then
  echo "Changing shell to /bin/bash for ${USER}"
  sudo chsh -s /bin/bash "${USER}"
fi

echo "🍀" > "$HOME/.user_sym"
echo "" > "$HOME/.hostname_sym"

echo -e "\n=> All done!"
