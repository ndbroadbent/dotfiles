#!/bin/bash
# See: https://docs.gitlab.com/ee/user/project/push_options.html

# Push, open a GitHub PR, and surface the latest pipeline status in Chrome.
_git_push_create_pr_and_open_pipeline() {
  git push "$@"
  gh pr create --fill || true
  gh pr view --web

  local current_git_branch current_git_commit pipeline_url
  current_git_branch="$(git rev-parse --abbrev-ref HEAD)"
  current_git_commit="$(git rev-parse HEAD)"
  pipeline_url="$(./scripts/circleci_pipeline_status -f "%u" -b "$current_git_branch" -c "$current_git_commit")"
  local chrome_bin="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  "$chrome_bin" "${pipeline_url}" 2>/dev/null
}

# Push and create GitHub PR, then wait for CI build to finish
gpsp() (
  set -euo pipefail
  _git_push_create_pr_and_open_pipeline "$@"
  [ -f scripts/wait_for_ci_build ] && scripts/wait_for_ci_build
)

# Push, open PR, approve staging deploy, and wait for CI build to finish
gpsps() (
  set -euo pipefail
  _git_push_create_pr_and_open_pipeline "$@"
  ./scripts/ci/approve staging
  [ -f scripts/wait_for_ci_build ] && scripts/wait_for_ci_build
)

alias gpssp='gpsps'
