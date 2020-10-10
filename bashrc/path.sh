# Android
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export ANDROID_SDK="$ANDROID_HOME"
export PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools"
export JAVA_HOME=$(/usr/libexec/java_home)

# YARN (Node)
export PATH="${PATH}:${HOME}/.yarn/bin"

# GNU utils
export PATH="${PATH}:/usr/local/opt/coreutils/libexec/gnubin"

# Dotfiles Scripts
export PATH="${PATH}:${DOTFILES_PATH}/bin"

# System Python
export PATH="${PATH}:${HOME}/Library/Python/2.7/bin/"

# Prefer Node modules in current dir
export PATH="./node_modules/.bin:${PATH}"

export PATH="${PATH}:/Users/ndbroadbent/anaconda/bin"
export PATH="${PATH}:/usr/local/opt/imagemagick/bin"
export PATH="${PATH}:/usr/local/opt/qt@5.5/bin"

# depot_tools (Chromium)
export PATH="${PATH}:/Users/ndbroadbent/code/depot_tools"

# rbenv (adds ~/.rbenv/shims to PATH)
eval "$(rbenv init -)"

# Rubocop daemon wrapper
# https://github.com/fohte/rubocop-daemon
export PATH="/usr/local/bin/rubocop-daemon-wrapper:${PATH}"
