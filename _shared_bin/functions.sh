# Shared functions for scripts in dotfiles/bin
# ------------------------------------------------

function rvmrc_or_default() {
  if type rvm > /dev/null 2>&1; then
    # Use .rvmrc, or default ruby
    if [ -e .rvmrc ]; then . .rvmrc; else rvm default; fi
  fi
}

function abort_if_revision_unchanged() {
  # Don't continue if revision hasn't changed since last time.
  if [ -e "$1" ]; then
    if grep -q "$(/usr/local/bin/git rev-parse HEAD)" "$1"; then
      # Revision hasn't changed since last time, nothing to do.
      exit
    fi
  fi
}

function store_current_revision() {
  # Store current revision so we don't keep processing unchanged projects
  git_exclude "$1"
  git rev-parse HEAD > "$1"
}
