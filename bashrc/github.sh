#!/bin/bash
# See: https://docs.gitlab.com/ee/user/project/push_options.html

# Push and create GitHub PR, then wait for CI build to finish
gpsp() (
  set -euo pipefail
  git push
  gh pr create --fill
  [ -f scripts/wait_for_ci_build ] && scripts/wait_for_ci_build
)
