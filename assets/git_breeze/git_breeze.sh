thisDir="$( cd -P "$( dirname "$0" )" && pwd )"

# Load config
source "$thisDir/config.sh"

source "$thisDir/lib/_shared.sh"
source "$thisDir/lib/aliases_and_bindings.sh"
source "$thisDir/lib/git_file_shortcuts.sh"
source "$thisDir/lib/git_repo_management.sh"
source "$thisDir/lib/git_tools.sh"

unset thisDir

