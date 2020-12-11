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

brew install mas mackup duti rbenv nvm git bash bash-completion wget curl yarn jq \
  ripgrep vim nano less htop unrar ffmpeg maven defaultbrowser \
  postgres redis imagemagick vim hugo watch gnupg binutils diffutils ed \
  heroku awscli getsentry/tools/sentry-cli \
  gzip screen file-formula openssh python rsync unzip \
  findutils coreutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gource \
  youtube-dl \
  crystal llvm

mkdir -p "$HOME/.rbenv/cache"
mkdir -p "$HOME/.nvm"

brew cask install google-chrome firefox \
  adoptopenjdk13 \
  flux rectangle dozer rescuetime \
  dropbox google-backup-and-sync \
  iterm2 visual-studio-code android-studio docker \
  virtualbox postico charles \
  zoom skype telegram spotify vlc sketch \
  sequel-pro db-browser-for-sqlite

# echo "Running brew cleanup..."
# brew cleanup

echo "Setting default browser to Google Chrome..."
defaultbrowser chrome
