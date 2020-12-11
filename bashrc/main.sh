export LC_ALL=en_US.UTF-8
# Hide "The default interactive shell is now zsh" on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

BASHRC_MODULES=" \
  auto_reload
  default
  functions
  ip
  aliases
  convox
  crystal
  docker
  haskell
  ruby_on_rails
  react_native
  golang
  java
  nvm
  prompt
  path
"

brew() {
  local BREW_PATH=$(which brew)
  local RESULT=$($BREW_PATH $@)
  echo -e "\033[1;31mDon't run 'brew $@' in your ~/.bashrc! (It's too slow.)" >&2
  echo -e "Replace this call with the result: $RESULT\033[0m" >&2
  printf "'brew $@' was called from: " >&2
  caller >&2
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

# SCM Breeze
[[ -n $DEBUG_BASHRC ]] && echo "Loading SCM Breeze..."
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

# Some custom git stuff that needs to be loaded after SCM Breeze
source "${DOTFILES_PATH}/bashrc/gitlab.sh"

# Rails Shell
[[ -n $DEBUG_BASHRC ]] && echo "Loading Rails Shell..."
source "$DOTFILES_PATH/rails_shell/rails_shell.sh"

# Finalize auto_reload sourced files
[[ -n $DEBUG_BASHRC ]] && echo "Finalizing Bash autoreload..."
finalize_auto_reload

# Fixes: +[__NSCFConstantString initialize] may have been in progress in another
# thread when fork() was called. See:
# * https://github.com/rbenv/ruby-build/issues/1385
# * https://github.com/puma/puma/issues/1421
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

unset -f brew
unset DEBUG_BASHRC
