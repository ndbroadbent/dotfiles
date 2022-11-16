#!/bin/bash
export LC_ALL=en_US.UTF-8
# Hide "The default interactive shell is now zsh" on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

BASHRC_MODULES=" \
  auto_reload
  default
  aliases
  functions
  path
  prompt
  convox
  crystal
  development
  docker
  golang
  haskell
  ip
  java
  nvm
  pyenv
  react_native
  ruby_on_rails
  yubikey
"

# DEBUG_BASHRC=true

# SCM Breeze
[[ -n $DEBUG_BASHRC ]] && echo "Loading SCM Breeze..."
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"


for BASHRC_MODULE in $BASHRC_MODULES; do
  [[ -n $DEBUG_BASHRC ]] && echo "Loading ${BASHRC_MODULE}..."
  source "${DOTFILES_PATH}/bashrc/${BASHRC_MODULE}.sh"
done
unset BASHRC_MODULE
SOURCED_FILES+=("$DOTFILES_PATH/bashrc/main.sh")

[[ -n $DEBUG_BASHRC ]] && echo "Loading Google Cloud SDK..."
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then
  source "$HOME/google-cloud-sdk/path.bash.inc"
fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.bash.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.bash.inc"
fi

# Some custom git stuff that needs to be loaded after SCM Breeze
source "${DOTFILES_PATH}/bashrc/gitlab.sh"
source "${DOTFILES_PATH}/bashrc/github.sh"

# Rails Shell
[[ -n $DEBUG_BASHRC ]] && echo "Loading Rails Shell..."
source "$DOTFILES_PATH/rails_shell/rails_shell.sh"

# Finalize auto_reload sourced files
[[ -n $DEBUG_BASHRC ]] && echo "Finalizing Bash autoreload..."
finalize_auto_reload

# Direnv - https://direnv.net
# Load .envrc in a directory after cd
# NOTE: Sets PROMPT_COMMAND, so has to come after finalize_auto_reload
eval "$(direnv hook bash)"

# Fixes: +[__NSCFConstantString initialize] may have been in progress in another
# thread when fork() was called. See:
# * https://github.com/rbenv/ruby-build/issues/1385
# * https://github.com/puma/puma/issues/1421
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

unset -f brew
unset DEBUG_BASHRC
