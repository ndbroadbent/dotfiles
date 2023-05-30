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
  local CURRENT_GIT_BRANCH STORY_ID STORY_COUNT STORY_JSON STORY_URL SENTRY_URL

  set -euo pipefail

  cd ~/code/docspring

  if ! \git diff --quiet 2>/dev/null; then
    echo "=> Git working tree is dirty. Please commit or stash your changes and try again." >&2
    return 1
  fi
  CURRENT_GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$CURRENT_GIT_BRANCH" != "main" ]]; then
    echo "=> Checking out main branch..." >&2
    \git checkout main
  fi

  if [[ "${_DEV_SCRIPT:-}" != "true" ]]; then
    echo "=> Opening iTerm2 tabs..." >&2
    osascript .dev.scpt "$(pwd)"
  else
    osascript -e 'tell application "iTerm" to activate' \
              -e 'tell application "System Events" to keystroke "f" using {command down, option down}'
  fi

  SHORT_SEARCH='owner:nathan state:"in development"'
  echo "Searching for stories: $SHORT_SEARCH" >&2
  STORY_IDS=$(short search "$SHORT_SEARCH" -f "%id")
  read -ra STORY_IDS <<< "$STORY_IDS"
  STORY_COUNT=${#STORY_IDS[@]}
  if [ "$STORY_COUNT" -eq 0 ]; then
    echo "No stories found." >&2
    return 1
  # elif [ "$STORY_COUNT" -gt 1 ]; then
  #   echo "Multiple stories found with state 'In Development':" "${STORY_IDS[*]}" >&2
  #   return 1
  fi
  # Use the first story in the list
  STORY_ID="${STORY_IDS[0]}"

  echo "Fetching story JSON..." >&2
  STORY_JSON=$(short st "$STORY_ID" -f "%j")
  STORY_URL=$(echo "$STORY_JSON" | jq -r '.app_url')

  # Create new git branch for story
  short st --git-branch-short "$STORY_ID"

  echo "=> Opening story in new Google Chrome window: ${STORY_URL}" >&2
  CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  "$CHROME_BIN" --new-window "${STORY_URL}" 2>/dev/null &
  sleep 3

  OPENED_SENTRY_URL='false'
  # Open any external links
  for EXTERNAL_LINK in $(echo "$STORY_JSON" | jq -r '.external_links | join("\n")'); do
    echo "=> Opening external link: ${EXTERNAL_LINK}" >&2
    "$CHROME_BIN" "${EXTERNAL_LINK}" 2>/dev/null &

    if [[ "${EXTERNAL_LINK}" == *"sentry.io"* ]]; then
      OPENED_SENTRY_URL='true'
    fi
  done

  if [ "$OPENED_SENTRY_URL" == 'false' ]; then
    # Find Sentry URL in the description (https://sentry.io/...)
    SENTRY_URL=$(echo "$STORY_JSON" | jq -r '.description' | grep -m1 -o 'https://sentry.io/[^ )]*' || true)

    # Open Sentry error (if present)
    if [ -n "$SENTRY_URL" ]; then
      echo "=> Opening Sentry error: ${SENTRY_URL}" >&2
      "$CHROME_BIN" "${SENTRY_URL}" 2>/dev/null &
    fi
  fi

  local WAS_RUNNING="false"
  if pgrep -f 'Visual Studio Code' > /dev/null; then
    WAS_RUNNING="true"
    echo "Opening Visual Studio Code in ${PWD}..." >&2
  else
    echo "Starting Visual Studio Code in ${PWD}..." >&2
  fi

  code .
  if [[ "$WAS_RUNNING" == "false" ]]; then
    sleep 8
  else
    sleep 3
  fi

  # Close all editor tabs and collapse all files in VS Code
  osascript "${DOTFILES_PATH}/applescript/reset-vscode.scpt"

  sleep 1
  osascript -e 'tell application "iTerm" to activate'

  echo "=> Starting Rails server..." >&2
  bin/rails server --binding=127.0.0.1 --port 3000 &

  echo "=> Waiting for Rails server to be ready..." >&2
  while ! curl -s http://app.docspring.local:3000/health > /dev/null; do
    sleep 1
    printf '.'
  done
  echo
  echo "=> Rails server is ready!" >&2
  sleep 1

  # Open DocSpring development URLs
  for DEV_URL in "http://admin.docspring.local:3000" "http://app.docspring.local:3000"; do
    echo "=> Opening development URL: ${DEV_URL}" >&2
    "$CHROME_BIN" "$DEV_URL" 2>/dev/null &
    sleep 1
  done

  # osascript -e 'tell application "Visual Studio Code" to activate'
  osascript -e 'tell application "Google Chrome" to activate'
  osascript -e 'tell application "Google Chrome" to set active tab index of last window to 1'

  osascript -e "display notification \"Story ${STORY_ID} is ready for development!\" with title \"Dev Setup Finished!\""

  wait

  osascript .dev.railsserver.scpt "$(pwd)"
)
