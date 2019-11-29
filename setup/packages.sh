#!/bin/bash
# Refs: https://gist.github.com/t-io/8255711

if ! which brew > /dev/null 2>&1; then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! [ -d "/usr/local/Homebrew/Library/Taps/heroku" ]; then
  brew tap heroku/brew
fi

brew install mackup rbenv nvm git bash wget curl yarn \
  ack vim nano less htop unrar ffmpeg \
  postgres redis imagemagick vim hugo watch heroku gnupg binutils diffutils ed \
  gzip screen file-formula openssh python rsync unzip \
  findutils coreutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep

mkdir -p "$HOME/.nvm"

brew cask install flux google-chrome firefox iterm2 spectacle \
  visual-studio-code virtualbox dropbox vlc charles skype telegram spotify docker

echo -e "\n====> Run the following commands after you've signed in to Dropbox:"
eho "      * mackup restore"
eho "      * dropbox_backup ssh -r"
eho "      * dropbox_backup convox -r"
# echo "Running brew cleanup..."
# brew cleanup
