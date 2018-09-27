BASHRC_MODULES=" \
  auto_reload
  default
  functions
  ip
  aliases
  convox
  docker
  ruby_on_rails
  capistrano
  golang
  java
  database_branches
  tmux
  prompt
  path
"

brew() {
  local BREW_PATH=$(which brew)
  local RESULT=$($BREW_PATH $@)
  echo -e "\033[1;31mDon't run 'brew $@' in your ~/.bashrc!" >&2
  echo -e "Replace this call with: $RESULT\033[0m" >&2
  echo $RESULT
}
# DEBUG_BASHRC=true

for BASHRC_MODULE in $BASHRC_MODULES; do
  [[ -n $DEBUG_BASHRC ]] && echo "Loading ${BASHRC_MODULE}..."
  source "${DOTFILES_PATH}/bashrc/${BASHRC_MODULE}.sh"
done
unset BASHRC_MODULE
SOURCED_FILES="$SOURCED_FILES $DOTFILES_PATH/bashrc/main.sh"

[[ -n $DEBUG_BASHRC ]] && echo "Loading Google Cloud SDK..."
# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/google-cloud-sdk/path.bash.inc' ]; then
  source '~/google-cloud-sdk/path.bash.inc'
fi
# The next line enables shell command completion for gcloud.
if [ -f '~/google-cloud-sdk/completion.bash.inc' ]; then
  source '~/google-cloud-sdk/completion.bash.inc'
fi

# NVM
[[ -n $DEBUG_BASHRC ]] && echo "Loading NVM..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# RVM
[[ -n $DEBUG_BASHRC ]] && echo "Loading RVM..."
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"

# SCM Breeze
[[ -n $DEBUG_BASHRC ]] && echo "Loading SCM Breeze..."
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

# Rails Shell
[[ -n $DEBUG_BASHRC ]] && echo "Loading Rails Shell..."
source "$DOTFILES_PATH/rails_shell/rails_shell.sh"

# Finalize auto_reload sourced files
[[ -n $DEBUG_BASHRC ]] && echo "Finalizing Bash autoreload..."
finalize_auto_reload

unset -f brew
unset DEBUG_BASHRC
