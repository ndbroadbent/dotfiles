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

# Use binaries from node_modules in the current dir.
# But don't prioritize these because there's an NPM package that
# also installs a 'which' binary, and this is annoying.
export PATH="${PATH}:./node_modules/.bin"

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

# Postgres 9.6
# export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/postgresql@9.6/lib"
# export CPPFLAGS="-I/usr/local/opt/postgresql@9.6/include"
# export PKG_CONFIG_PATH="/usr/local/opt/postgresql@9.6/lib/pkgconfig"
