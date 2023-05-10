#!/usr/bin/env bash
# Refs: https://gist.github.com/t-io/8255711

if ! which brew > /dev/null 2>&1; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install homebrew autoupdate
brew tap homebrew/autoupdate
brew autoupdate start || true

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

# brew tap petere/postgresql

brew install mas mackup duti direnv rbenv nvm pyenv git bash bash-completion wget curl yarn jq \
  ripgrep vim less htop ffmpeg maven defaultbrowser \
  redis imagemagick vim hugo watch gnupg binutils diffutils ed reattach-to-user-namespace \
  heroku awscli getsentry/tools/sentry-cli \
  gzip screen file-formula openssh python rust rsync unzip terraform \
  findutils coreutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gource \
  crystal llvm yt-dlp bat starship

mkdir -p "$HOME/.rbenv/cache"
mkdir -p "$HOME/.nvm"

# Cloning the homebrew cask tap is extremely slow. Just checkout with depth 1.
if ! [ -d "/usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask" ]; then
  mkdir -p /usr/local/Homebrew/Library/Taps/caskroom/
  git clone --depth 1 https://github.com/caskroom/homebrew-cask.git \
    /usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask
fi

# Fira fonts
if ! [ -d "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-fonts" ]; then
  brew tap homebrew/cask-fonts
fi

brew install --cask firefox google-chrome \
  adoptopenjdk13 \
  flux dozer rectangle muzzle rescuetime qbittorrent \
  iterm2 visual-studio-code android-studio docker \
  virtualbox postgres-unofficial postico db-browser-for-sqlite charles \
  skype zoom slack telegram spotify vlc \
  dropbox notion \
  bambu-studio openscad \
  font-fira-code font-fira-mono font-fira-sans

# echo "Running brew cleanup..."
# brew cleanup

echo "Setting default browser to Google Chrome..."
defaultbrowser chrome
