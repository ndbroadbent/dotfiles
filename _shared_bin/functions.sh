# Shared functions for scripts in dotfiles/bin
# ------------------------------------------------

[[ -s "$HOME/.scm_breeze/scm_breeze.sh" ]] && source "$HOME/.scm_breeze/scm_breeze.sh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export GIT_BINARY=$(which git)

ensure_gem () {
  if ! gem list $1 | grep --color=auto -q $1; then
    gem install $1;
  fi
}

rvmrc_or_default() {
  if type rvm > /dev/null 2>&1; then
    # Use .rvmrc, or default ruby
    if [ -e .rvmrc ]; then
      if ! . .rvmrc; then
        # Quit if ruby version not installed.
        echo "Aborting: . .rvmrc failed!"
        exit
      fi
    else
      rvm default
    fi
  fi
}

abort_if_revision_unchanged() {
  # Abort if no HEAD commit
  $GIT_BINARY rev-parse HEAD > /dev/null 2>&1 || exit

  # Don't continue if revision hasn't changed since last time.
  if [ -e "$1" ]; then
    if grep -q "$($GIT_BINARY rev-parse HEAD)" "$1"; then
      echo "No changes in $(pwd)"
      exit
    fi
  fi
}

store_current_revision() {
  # Store current revision so we don't keep processing unchanged projects
  git_exclude "$1"
  $GIT_BINARY rev-parse HEAD > "$1"
}
