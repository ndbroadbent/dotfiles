#
# Get directory of this file (for bash and zsh).
# git_breeze.sh must not be run directly.
# It must be sourced, e.g "source ~/.git_breeze/git_breeze.sh"
thisDir="$(dirname ${BASH_SOURCE:-$0})"

# Load config
source "$thisDir/config.sh"

source "$thisDir/lib/_shared.sh"
source "$thisDir/lib/aliases_and_bindings.sh"
source "$thisDir/lib/git_file_shortcuts.sh"
source "$thisDir/lib/git_repo_management.sh"
source "$thisDir/lib/git_tools.sh"

unset thisDir

