#!/bin/bash
# See: https://docs.gitlab.com/ee/user/project/push_options.html

# Push and create GitHub PR, then wait for CI build to finish
gpsp() (
  set -euo pipefail
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
)
