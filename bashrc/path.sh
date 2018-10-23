# Android
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"

# YARN (Node)
export PATH="${PATH}:${HOME}/.yarn/bin"

# NPM
export PATH="${PATH}:./node_modules/.bin"

# RVM (Ruby)
export PATH="${PATH}:${HOME}/.rvm/bin"

# GNU utils
export PATH="${PATH}:/usr/local/opt/coreutils/libexec/gnubin"

# Dotfiles Scripts
export PATH="${PATH}:${DOTFILES_PATH}/bin"

# System Python
export PATH="${PATH}:${HOME}/Library/Python/2.7/bin/"

# Node modules in current dir
export PATH="${PATH}:node_modules/.bin"

export PATH="${PATH}:/Users/ndbroadbent/anaconda/bin"
export PATH="${PATH}:/usr/local/opt/imagemagick/bin"
export PATH="${PATH}:/usr/local/opt/qt@5.5/bin"

# Prefer binstubs in Rails applications over binaries from RVM gems
# e.g. rspec is wrapped with the spring preloader
export PATH="./bin:${PATH}"
