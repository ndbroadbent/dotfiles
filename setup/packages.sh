#!/bin/bash
# Refs: https://gist.github.com/t-io/8255711

if ! which brew > /dev/null 2>&1; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! [ -d "/usr/local/Homebrew/Library/Taps/heroku" ]; then
  brew tap heroku/brew
fi

brew install mackup rbenv nvm git bash wget curl yarn \
  ack vim nano less htop unrar ffmpeg \
  postgresql imagemagick vim hugo watch heroku gnupg binutils diffutils ed \
  gzip screen file-formula openssh python rsync unzip \
  findutils coreutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep

brew cask install flux google-chrome firefox iterm2 spectacle \
  visual-studio-code virtualbox dropbox vlc charles skype spotify docker

echo -e "\n====> Run 'mackup restore' after you've signed in to Dropbox.\n"
# echo "Running brew cleanup..."
# brew cleanup
