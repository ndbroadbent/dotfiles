#!/bin/bash
# Refs: https://gist.github.com/t-io/8255711

if ! which brew > /dev/null 2>&1; then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! [ -d "/usr/local/Homebrew/Library/Taps/heroku" ]; then
  brew tap heroku/brew
fi

# Install Java and maven
if /usr/libexec/java_home -V 2>&1 | grep "No Java runtime"; then
  if ! [ -d "/usr/local/Homebrew/Library/Taps/adoptopenjdk" ]; then
    brew tap AdoptOpenJDK/openjdk
  fi
  echo "Installing Java..."
  brew cask install adoptopenjdk8
fi

brew install mas mackup rbenv nvm git bash bash-completion wget curl yarn jq \
  ack the_silver_searcher vim nano less htop unrar ffmpeg maven defaultbrowser \
  postgres redis imagemagick vim hugo watch gnupg binutils diffutils ed \
  heroku awscli \
  gzip screen file-formula openssh python rsync unzip \
  findutils coreutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gource \
  youtube-dl

mkdir -p "$HOME/.rbenv/cache"
mkdir -p "$HOME/.nvm"

brew cask install google-chrome firefox iterm2 \
  flux rectangle dozer \
  visual-studio-code virtualbox vlc charles skype telegram spotify docker  \
  dropbox google-backup-and-sync \
  rescuetime

# echo "Running brew cleanup..."
# brew cleanup

echo "Setting default browser to Google Chrome..."
defaultbrowser chrome
