# See: https://docs.gitlab.com/ee/user/project/push_options.html

# Create a new merge request if it doesn't already exist.
# Update: don't automatically merge when pipeline succeeds (-o merge_request.merge_when_pipeline_succeeds)
# We deploy from branches, and then merge to main after it's deployed.
alias gpsm="git push -o merge_request.create -o merge_request.target=main && [ -f scripts/wait_for_ci_build ] && scripts/wait_for_ci_build"

alias gmm="export CURRENT_BRANCH=\"\$(git rev-parse --abbrev-ref HEAD 2> /dev/null)\" \
&& git checkout main && git pull origin main && git merge \$CURRENT_BRANCH"
alias gmmp="gmm && git push origin main && (git branch -D \$CURRENT_BRANCH || true) && git push origin :\$CURRENT_BRANCH"

push_wait_deploy() {
  export CURRENT_GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [ "$?" != '0' ] || [ -z "$CURRENT_GIT_BRANCH" ]; then
    echo "Error fetching current git branch"
    return 1
  fi

  git push -o merge_request.create -o merge_request.target=main || return
  ./scripts/wait_for_ci_build || return

  ( osascript -e "display notification \"Get ready to touch your Yubikey for 2FA...\" with title \"Deploying...\"" &) &> /dev/null
  ./scripts/deploy || return

  LATEST_GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  # Check if branch is the same
  if [ "$CURRENT_GIT_BRANCH" != "$LATEST_GIT_BRANCH" ]; then
    echo "Git branch has changed. Please run 'gmmp' to merge your changes into main."
    return 1
  fi

  git checkout main || return
  git pull origin main || return
  git merge "$CURRENT_GIT_BRANCH" || return

  git push origin main || return
  (git branch -D $CURRENT_GIT_BRANCH || true)
  git push origin ":$CURRENT_GIT_BRANCH" || return
}
