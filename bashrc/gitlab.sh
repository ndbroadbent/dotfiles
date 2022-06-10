# See: https://docs.gitlab.com/ee/user/project/push_options.html

# Create a new merge request if it doesn't already exist.
# Update: don't automatically merge when pipeline succeeds (-o merge_request.merge_when_pipeline_succeeds)
# We deploy from branches, and then merge to main after it's deployed.
alias gpsm="git push -o merge_request.create -o merge_request.target=main && [ -f scripts/wait_for_ci_build ] && scripts/wait_for_ci_build"
