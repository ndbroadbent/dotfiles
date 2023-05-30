alias ds='osascript .dev.scpt "$(pwd)" &'
alias dds='cd ~/code/docspring && ds'
alias sds='cd ~/code/spin && ds'
alias d='cd ~/code/docspring'

alias da='direnv allow'

# Git
# -------------------------------------------------
# Adds all changes to current commit and then force pushes.
# Never use this on a team project!!
alias GFORCE='git add -A && git commit --amend -C HEAD && git push -f'

# A bash alias that checks out the main branch, pulls the latest changes,
# checks out the previous branch, and then rebases onto main.
alias grbl='MAIN_BRANCH=$((! [ -f .git/config ] && echo "master") || (grep -q '"'"'branch "master"'"'"' .git/config && echo master || echo main)) && git checkout "$MAIN_BRANCH" && git pull && git checkout - && git rebase "$MAIN_BRANCH"'

# Gitlab CI (DocSpring)
# -------------------------------------------------
# Show latest CI pipeline in terminal
alias ci="./scripts/circleci_pipeline_status -f '#%n: %s. URL: %u'"
# Show latest CI pipeline in browser
alias sci="./scripts/show_latest_circleci_pipeline"
# Run failed tests from the most recent failed CI pipeline
alias rci="./scripts/run_failed_ci_pipeline_specs"
# Refresh CI status in prompt
alias rfci="./scripts/circleci_pipeline_status > /dev/null"

# Delete git branch locally and on remote
function gbDA() {
  if [ "$1" == 'master' ] || [ "$1" == 'main' ]; then
    echo "Cannot delete $1 branch."
    return 1
  fi
  _scmb_git_branch_shortcuts -D "$1";
  exec_scmb_expand_args git push origin --delete "$1";
}


# Shortcut.com
# ------------------------------------------------
# Create new git branch for a story ID
alias stb="short st --git-branch-short"

# - Open all development tabs in iTerm2
# - Start and reset VS Code (close all files, collapse folders)
# - Start git branch for current story in development
# - Open story in new Chrome window
dev() (
  cd ~/code/docspring || exit
  ./scripts/dev_iterm
)
