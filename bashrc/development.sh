alias ds='osascript .dev.scpt "$(pwd)" &'
alias dds='cd ~/code/docspring && ds'
alias sds='cd ~/code/spin && ds'
alias d='cd ~/code/docspring'

alias da='direnv allow'

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

  osascript -e 'tell application "iTerm" to activate' \
            -e 'tell application "System Events" to keystroke "f" using {command down, option down}'

  cd ~/code/docspring
  if [[ "${_DEV_SCRIPT:-}" != "true" ]]; then
    osascript .dev.scpt "$(pwd)"
  fi

  local STORY_ID_AND_URL=$(short search 'owner:nathan state:"in development"' -f "%id;%u")
  local STORY_COUNT="$(echo "$STORY_ID_AND_URL" | wc -l)"
  if [ "$STORY_COUNT" -eq 0 ]; then
    echo "No stories found."
    return 1
  elif [ "$STORY_COUNT" -gt 1 ]; then
    echo "Multiple stories found with state 'In Development':" $STORY_ID_AND_URL
    return 1
  fi
  local STORY_ID=$(echo $STORY_ID_AND_URL | cut -d ';' -f 1)
  local STORY_URL=$(echo $STORY_ID_AND_URL | cut -d ';' -f 2)

  # Create new git branch for story
  short st --git-branch-short "$STORY_ID"

  echo "Opening story in new Google Chrome window: ${STORY_URL}"
  CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  "$CHROME_BIN" --new-window "${STORY_URL}" 2>/dev/null
  "$CHROME_BIN" "http://admin.docspring.local:3000" 2>/dev/null
  "$CHROME_BIN" "http://app.docspring.local:3000" 2>/dev/null

  local WAS_RUNNING="false"
  if pgrep -f 'Visual Studio Code' > /dev/null; then WAS_RUNNING="true"; fi
  echo "Starting Visual Studio Code in ${PWD}..."
  code .
  if [[ "$WAS_RUNNING" == "false" ]]; then
    sleep 10
  else
    sleep 1
  fi

  # Close all editor tabs and collapse all files in VS Code
  osascript "${DOTFILES_PATH}/applescript/reset-vscode.scpt"
)
