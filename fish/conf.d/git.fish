# Git Keyboard Shortcuts
bind \cx git_commit_all_keybinding
bind \cxc git_add_and_commit_keybinding

abbr -a grsl 'git reset HEAD~'
abbr -a gcm 'git commit --amend'
abbr -a gcmh 'git commit --amend -C HEAD'
abbr -a gdc 'git diff --cached'

abbr -a gbd 'git branch -d'
abbr -a gbD 'git branch -D'

function grbi
    if test (count $argv) -eq 0
        git rebase -i HEAD~10
    else
        git rebase -i $argv
    end
end

alias gpsp 'bash -c '"'"'
git_push_open_pr_wait_for_ci() {
  set -euo pipefail
  echo "Pushing changes to GitHub..."
  git push
  gh pr create --fill || true
  gh pr view --web
  local CURRENT_GIT_BRANCH CURRENT_GIT_COMMIT
  CURRENT_GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  CURRENT_GIT_COMMIT="$(git rev-parse HEAD)"
  PIPELINE_URL="$(./scripts/circleci_pipeline_status -f "%u" -b "$CURRENT_GIT_BRANCH" -c "$CURRENT_GIT_COMMIT")"
  local CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  "$CHROME_BIN" "${PIPELINE_URL}" 2>/dev/null
  [ -f scripts/wait_for_ci_build ] && scripts/wait_for_ci_build
}
git_push_open_pr_wait_for_ci
'"'"

alias gpsw 'bash -c '"'"'
set -euo pipefail
echo "Pushing changes to GitHub..."
git push
[ -f scripts/wait_for_ci_build ] && scripts/wait_for_ci_build
'"'"
