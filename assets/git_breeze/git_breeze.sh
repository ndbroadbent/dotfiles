#
# Get directory of this file (for bash and zsh).
# git_breeze.sh must not be run directly.
# It must be sourced, e.g "source ~/.git_breeze/git_breeze.sh"
# ------------------------------------------------------------

export gitbreezeDir="$(dirname ${BASH_SOURCE:-$0})"

# Load config
. "$gitbreezeDir/config.sh"

. "$gitbreezeDir/lib/_shared.sh"
. "$gitbreezeDir/lib/aliases_and_bindings.sh"
. "$gitbreezeDir/lib/git_status_shortcuts.sh"
. "$gitbreezeDir/lib/git_repo_management.sh"
. "$gitbreezeDir/lib/git_tools.sh"


if ! type ruby > /dev/null 2>&1; then
  # If Ruby is not installed, fall back to the
  # slower bash/zsh implementation of 'git_status_shortcuts'
  . "$gitbreezeDir/lib/fallback/git_status_shortcuts_shell.sh"
fi

