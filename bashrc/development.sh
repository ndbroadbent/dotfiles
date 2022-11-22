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
  set -euo pipefail

  cd ~/code/docspring
  if [[ "${_DEV_SCRIPT:-}" != "true" ]]; then
    osascript .dev.scpt "$(pwd)"
  else
    osascript -e 'tell application "iTerm" to activate' \
              -e 'tell application "System Events" to keystroke "f" using {command down, option down}'
  fi

  local STORY_ID_AND_URL
  STORY_ID_AND_URL=$(short search 'owner:nathan state:"in development"' -f "%id;%u")
  local STORY_COUNT
  STORY_COUNT="$(echo "$STORY_ID_AND_URL" | wc -l)"
  if [ "$STORY_COUNT" -eq 0 ]; then
    echo "No stories found."
    return 1
  elif [ "$STORY_COUNT" -gt 1 ]; then
    echo "Multiple stories found with state 'In Development':" "$STORY_ID_AND_URL"
    return 1
  fi
  local STORY_ID
  STORY_ID=$(echo "$STORY_ID_AND_URL" | cut -d ';' -f 1)
  local STORY_URL
  STORY_URL=$(echo "$STORY_ID_AND_URL" | cut -d ';' -f 2)

  echo "Fetching story description..."
  local STORY_DESCRIPTION
  STORY_DESCRIPTION=$(short st "$STORY_ID" -f "%d")
  # Find first Sentry URL in the description (https://sentry.io/...)
  local SENTRY_URL
  SENTRY_URL=$(echo "$STORY_DESCRIPTION" | grep -m1 -o 'https://sentry.io/[^ )]*' || true)

  # Create new git branch for story
  short st --git-branch-short "$STORY_ID"

  echo "Opening story in new Google Chrome window: ${STORY_URL}"
  CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  "$CHROME_BIN" --new-window "${STORY_URL}" 2>/dev/null
  # Open Sentry error (if present)
  if [ -n "$SENTRY_URL" ]; then
    echo "Opening Sentry error: ${SENTRY_URL}"
    "$CHROME_BIN" "${SENTRY_URL}" 2>/dev/null
  fi
  # Open DocSpring development URLs
  "$CHROME_BIN" "http://admin.docspring.local:3000" 2>/dev/null
  "$CHROME_BIN" "http://app.docspring.local:3000" 2>/dev/null

  local WAS_RUNNING="false"
  if pgrep -f 'Visual Studio Code' > /dev/null; then WAS_RUNNING="true"; fi
  echo "Starting Visual Studio Code in ${PWD}..."
  code .
  if [[ "$WAS_RUNNING" == "false" ]]; then
    sleep 8
  else
    sleep 3
  fi

  # Close all editor tabs and collapse all files in VS Code
  osascript "${DOTFILES_PATH}/applescript/reset-vscode.scpt"
)

