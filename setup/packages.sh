#!/bin/bash
# Refs: https://gist.github.com/t-io/8255711

if ! which brew > /dev/null 2>&1; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install homebrew autoupdate
brew tap homebrew/autoupdate
brew autoupdate start

if ! [ -d "/usr/local/Homebrew/Library/Taps/heroku" ]; then
  brew tap heroku/brew
fi

# Install Java and maven
if ! /usr/libexec/java_home -V; then
  if ! [ -d "/usr/local/Homebrew/Library/Taps/adoptopenjdk" ]; then
    brew tap AdoptOpenJDK/openjdk
  fi
  echo "Installing Java..."
  brew install --cask adoptopenjdk/openjdk/adoptopenjdk8
fi

brew install mas mackup duti direnv rbenv nvm git bash bash-completion wget curl yarn jq \
  ripgrep vim less htop ffmpeg maven defaultbrowser \
  postgres redis imagemagick vim hugo watch gnupg binutils diffutils ed \
  heroku awscli getsentry/tools/sentry-cli \
  gzip screen file-formula openssh python rsync unzip \
  findutils coreutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gource \
  youtube-dl \
  crystal llvm

mkdir -p "$HOME/.rbenv/cache"
mkdir -p "$HOME/.nvm"


# Cloning the homebrew cask tap is extremely slow. Just checkout with depth 1.
if ! [ -d /usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask ]; then
  mkdir -p /usr/local/Homebrew/Library/Taps/caskroom/
  git clone --depth 1 https://github.com/caskroom/homebrew-cask.git \
    /usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask
fi

brew install --cask firefox google-chrome \
  adoptopenjdk13 \
  flux dozer rectangle muzzle background-music rescuetime qbittorrent \
  iterm2 visual-studio-code android-studio docker \
  virtualbox postico db-browser-for-sqlite charles \
  skype zoom slack telegram spotify vlc \
  dropbox google-backup-and-sync

# echo "Running brew cleanup..."
# brew cleanup

echo "Setting default browser to Google Chrome..."
defaultbrowser chrome
