#!/bin/bash
# Mise
export PATH="$HOME/.local/share/mise/shims:${PATH}"
# Homebrew
export PATH="/opt/homebrew/bin:${PATH}"

export PATH="${PATH}:~/.local/bin"

# Android
# export ANDROID_HOME="${HOME}/Library/Android/sdk"
# export ANDROID_SDK="$ANDROID_HOME"
export PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools"

export JAVA_HOME="/opt/homebrew/opt/openjdk@23"
export PATH="/opt/homebrew/opt/openjdk@23/bin:${PATH}"

# pnpm
export PNPM_HOME="/Users/ndbroadbent/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# YARN (Node)
export PATH="${PATH}:${HOME}/.yarn/bin"

# Dotfiles Scripts
export PATH="${PATH}:${DOTFILES_PATH}/bin"

# System Python
export PATH="${PATH}:${HOME}/Library/Python/2.7/bin/"

# Use binaries from node_modules in the current dir.
# But don't prioritize these because there's an NPM package that
# also installs a 'which' binary, and this is annoying.
export PATH="${PATH}:./node_modules/.bin"

export PATH="${PATH}:/Users/ndbroadbent/anaconda/bin"
export PATH="${PATH}:/opt/homebrew/opt/imagemagick/bin"
export PATH="${PATH}:/opt/homebrew/opt/qt@5.5/bin"

# depot_tools (Chromium)
export PATH="${PATH}:/Users/ndbroadbent/code/depot_tools"

# Postgres 9.6
# export PATH="/opt/homebrew/opt/postgresql@9.6/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/postgresql@9.6/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/postgresql@9.6/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@9.6/lib/pkgconfig"

# Postgres.app
export PATH="/Applications/Postgres.app/Contents/Versions/15/bin:${PATH}"

# GNU utils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# Old PHP 7.4 for API client tests
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Use local ./bin directory for executables
export PATH="./bin:$PATH"

# Terraform wrapper to speed up convox commands
export PATH="$HOME/code/convox_racks_terraform/scripts/terraform_wrapper:${PATH}"
